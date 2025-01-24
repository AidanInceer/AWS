import requests

import boto3
from botocore.exceptions import ClientError


def lambda_handler(event, context):

    load_user_data()

    return {"statusCode": 200, "body": "Success"}


def load_user_data():
    print("fetching secret")
    secret = get_secret()

    url = "https://euw1.api.riotgames.com/tft/league/v1/challenger?queue=RANKED_TFT"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
        "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
        "Accept-Charset": "application/x-www-form-urlencoded; charset=UTF-8",
        "Origin": "https://developer.riotgames.com",
        "X-Riot-Token": f"{secret}",
    }
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        print(response.status_code)
        return response.json()
    else:
        print(f"Failed to get summoner: {response.status_code}, {response.text}")
        print(response.text)
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


if __name__ == "__main__":
    load_user_data()

"""
1. /tft/league/v1/challenger access league/account ids
2. /tft/summoner/v1/summoners/by-account/{encryptedAccountId} get puuids
3. /tft/match/v1/matches/by-puuid/{puuid}/ids  get match_id list by puuid
4. /tft/match/v1/matches/{matchId} get match details by match id
"""
