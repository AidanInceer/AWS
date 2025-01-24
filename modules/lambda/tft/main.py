import requests

import boto3
from botocore.exceptions import ClientError
import json
from datetime import datetime
import time


def lambda_handler(event, context):
    secret = get_secret()

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
        "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
        "Accept-Charset": "application/x-www-form-urlencoded; charset=UTF-8",
        "Origin": "https://developer.riotgames.com",
        "X-Riot-Token": f"{secret}",
    }

    for div in ["challenger", "grandmaster", "master"]:

        s3 = boto3.client("s3")
        current_date = datetime.now().strftime("%Y-%m-%d")
        bucket_name = "tft-project-dev-bucket"

        data = load_division_data(s3, current_date, bucket_name, div, headers)

        limit = 10
        summoner_ids = extract_summoner_ids(data, limit=limit)
        puuids = save_all_summoner_data(
            summoner_ids, div, headers, s3, bucket_name, current_date, limit
        )

        match_ids = fetch_all_match_ids(puuids, headers)

        extract_all_match_data(match_ids, headers, s3, bucket_name, current_date)

    return "All JSON files successfully uploaded to S3!"


def load_division_data(
    s3, current_date: str, bucket_name: str, div: str, headers: dict
):
    print("fetching division data")
    url = f"https://euw1.api.riotgames.com/tft/league/v1/{div}?queue=RANKED_TFT"
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        print(f"fetched division data for: {div}")

        save_to_s3(
            s3=s3,
            data=json.dumps(response.json()),
            bucket_name=bucket_name,
            object_key=f"{current_date}/division_data/{div}.json",
            content_type="application/json",
        )

        return response.json()
    else:
        print(f"Failed to get summoner: {response.status_code}, {response.text}")
        print(response.text)
        return None


def save_all_summoner_data(
    summoner_ids: list,
    div: str,
    headers: dict,
    s3,
    bucket_name: str,
    current_date: str,
    limit: int,
):
    puuid_list = []
    for index, id in enumerate(summoner_ids):
        data = load_summoner_data(id, headers)
        print(f"({index + 1}/{limit}) Fetched summoner data for: {id}")

        puuid_list.append(data["puuid"])

        save_to_s3(
            s3=s3,
            data=json.dumps(data),
            bucket_name=bucket_name,
            object_key=f"{current_date}/summoners/{div}/{id}.json",
            content_type="application/json",
        )
        print(f"({index + 1}/{limit}) Saved summoner data to s3 for: {id}")

    return puuid_list


def load_summoner_data(summoner_id: str, headers: dict):
    url = f"https://euw1.api.riotgames.com/tft/summoner/v1/summoners/{summoner_id}"
    response = requests.get(url, headers=headers)
    time.sleep(0.85)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to get summoner: {response.status_code}, {response.text}")
        return None


def extract_summoner_ids(data: dict, limit: int):
    players = data["entries"][0:limit]
    return [player["summonerId"] for player in players]


def fetch_all_match_ids(puuids: str, headers: dict):
    match_list = []
    for puuid in puuids:
        url = f"https://europe.api.riotgames.com/tft/match/v1/matches/by-puuid/{puuid}/ids?start=-1&count=10"
        response = requests.get(url, headers=headers)
        time.sleep(0.85)
        if response.status_code == 200:
            match_list.append(response.json())
        else:
            print(f"Failed to get match list: {response.status_code}, {response.text}")

    all_matches = [match_id for user_matches in match_list for match_id in user_matches]
    return list(set(all_matches))


def extract_all_match_data(
    match_ids: list, headers: dict, s3, bucket_name: str, current_date: str
):
    for index, match_id in enumerate(match_ids):
        data = load_match_data(match_id, headers)
        print(f"({index + 1}/{len(match_ids)}) Fetched match data for: {match_id}")

        save_to_s3(
            s3=s3,
            data=json.dumps(data),
            bucket_name=bucket_name,
            object_key=f"{current_date}/matches/{match_id}.json",
            content_type="application/json",
        )
        print(f"({index + 1}/{len(match_ids)}) Saved match data to s3 for: {match_id}")


def load_match_data(match_id: str, headers: dict):
    url = f"https://europe.api.riotgames.com/tft/match/v1/matches/{match_id}"
    response = requests.get(url, headers=headers)
    time.sleep(0.85)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to get match: {response.status_code}, {response.text}")
        return None


def get_secret():
    secret_name = "RIOT_API_KEY"
    region_name = "eu-west-2"

    session = boto3.session.Session()
    client = session.client(service_name="secretsmanager", region_name=region_name)

    try:
        return (
            client.get_secret_value(SecretId=secret_name)["SecretString"]
            .split(":")[1]
            .replace('"', "")
            .replace("}", "")
        )
    except ClientError as e:
        raise e


def save_to_s3(s3, data, bucket_name: str, object_key: str, content_type: str):
    try:
        s3.put_object(
            Bucket=bucket_name,
            Key=object_key,
            Body=data,
            ContentType=content_type,
        )

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps(
                {"message": "Failed to upload data to S3", "error": str(e)}
            ),
        }


# if __name__ == "__main__":
#     lambda_handler(None, None)
