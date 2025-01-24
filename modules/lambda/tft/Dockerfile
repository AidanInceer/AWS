# Use the official AWS Lambda Python runtime base image
FROM public.ecr.aws/lambda/python:3.12

# Copy your application code and requirements file to the working directory
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Install the Python dependencies
RUN pip install -r requirements.txt

COPY main.py ${LAMBDA_TASK_ROOT}

# Command to run your Lambda function handler
CMD ["main.lambda_handler"]
