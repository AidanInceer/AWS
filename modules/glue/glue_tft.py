import sys
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

# Initialize Glue Context
args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Read CSV from S3
source = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://${s3_bucket_name}/${s3_file_key}"]},
    format="csv",
    format_options={"withHeader": True},
)

# Write to Redshift Serverless
glueContext.write_dynamic_frame.from_options(
    frame=source,
    connection_type="redshift",
    connection_options={
        "url": "jdbc:redshift://example-workgroup.${aws_region}.redshift-serverless.amazonaws.com:5439/dev",
        "user": "admin",  # Replace with your Redshift user
        "password": "password",  # Replace with your Redshift password
        "dbtable": "your_table_name",  # Replace with your Redshift table name
    },
)

# Commit Job

job.commit()
