import os
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ValidationError
from uuid import uuid4
from Customers import Customer, UpdateCustomer
from azure.cosmos import CosmosClient
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
from azure.cosmos.exceptions import CosmosResourceNotFoundError

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods
    allow_headers=["*"],  # Allow all headers
)

# Get Cosmos DB client
load_dotenv()
COSMOS_ENDPOINT = os.getenv("COSMOS_ENDPOINT")

credential = DefaultAzureCredential()
client = CosmosClient(url=COSMOS_ENDPOINT, credential=credential)
database = client.get_database_client("mydb")
container = database.get_container_client("customers")

@app.post("/api/customers")
async def createCustomer(customer: Customer):
    """
    Creates a new customer entry in the database from the HTTP request data.

    This function is triggered by an HTTP POST request. It expects a JSON payload
    with the customer's details, validates the data using the Customer model, and then
    saves the new customer document to Cosmos DB. If the data is invalid or the request
    cannot be processed, it returns an appropriate HTTP response.

    Args:
        customer (Customer): The HTTP request object containing the Customer data.

    Returns:
        dict: The created customer document if successful.
        Raises HTTPException with status code 400 if the request data is invalid or not in JSON format.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Validate the customer data
        new_customer = customer.dict()
        new_customer["id"] = str(uuid4())

        # Save the new customer to the database
        container.create_item(body=new_customer)
        return new_customer
    except ValidationError as ve:
        raise HTTPException(status_code=400, detail="Invalid input data")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/customers")
async def getCustomers():
    """
    Retrieves a list of all customers from the database.

    This function is triggered by an HTTP GET request. It retrieves all customer
    documents from the Cosmos DB container and returns them as a list. If the
    request cannot be processed, it returns an appropriate HTTP response.

    Returns:
        list: A list of customer documents.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Get all customers from the database
        customers = list(container.query_items(
            query="SELECT * FROM c",
            enable_cross_partition_query=True
        ))
        return customers
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/customers/{customer_id}")
async def getCustomer(customer_id: str):
    """
    Retrieves a specific customer from the database by ID.

    This function is triggered by an HTTP GET request. It retrieves the customer
    document with the specified ID from the Cosmos DB container. If the customer
    does not exist or the request cannot be processed, it returns an appropriate
    HTTP response.

    Args:
        customer_id (str): The ID of the customer to retrieve.

    Returns:
        dict: The customer document with the specified ID.
        Raises HTTPException with status code 404 if the customer does not exist.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Query the customer by ID
        customer = container.read_item(item=customer_id, partition_key=customer_id)
        return customer
    except CosmosResourceNotFoundError:
        raise HTTPException(status_code=404, detail="Customer not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/api/customers/{customer_id}")
async def updateCustomer(customer_id: str, customer: UpdateCustomer):
    """
    Updates an existing customer document in the database.

    This function is triggered by an HTTP PUT request. It expects a JSON payload
    with the updated customer data and the ID of the customer to update. It validates
    the data using the UpdateCustomer model and then updates the customer document in
    Cosmos DB. If the data is invalid or the request cannot be processed, it returns
    an appropriate HTTP response.

    Args:
        customer_id (str): The ID of the customer to update.
        customer (UpdateCustomer): The HTTP request object containing the updated data.

    Returns:
        dict: The updated customer document if successful.
        Raises HTTPException with status code 400 if the request data is invalid or not in JSON format.
        Raises HTTPException with status code 404 if the customer is not found.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Retrieve the existing document
        try:
            existing_customer = container.read_item(item=customer_id, partition_key=customer_id)
        except CosmosResourceNotFoundError:
            raise HTTPException(status_code=404, detail="Customer not found")

        # Update the document with fields provided in the request
        update_data = customer.dict(exclude_unset=True)
        for field, value in update_data.items():
            if field in existing_customer and value is not None:
                existing_customer[field] = value

        # Upsert the updated document
        container.upsert_item(existing_customer)
        return existing_customer
    except ValidationError as ve:
        raise HTTPException(status_code=400, detail="Invalid input data")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.delete("/api/customers/{customer_id}")
async def deleteCustomer(customer_id: str):
    """
    Deletes a customer document from the database by ID.

    This function is triggered by an HTTP DELETE request. It deletes the customer
    document with the specified ID from the Cosmos DB container. If the customer
    does not exist or the request cannot be processed, it returns an appropriate
    HTTP response.

    Args:
        customer_id (str): The ID of the customer to delete.

    Returns:
        dict: A message indicating the deletion was successful.
        Raises HTTPException with status code 404 if the customer does not exist.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Query the customer by ID
        try:
            container.read_item(item=customer_id, partition_key=customer_id)
        except CosmosResourceNotFoundError:
            raise HTTPException(status_code=404, detail="Customer not found")

        # Delete the customer from the database
        container.delete_item(item=customer_id, partition_key=customer_id)
        return {"message": "Customer deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))