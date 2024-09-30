resource "azurerm_api_management_api" "books" {
  name                = "books"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Books"
  protocols           = ["https"]
}

resource "azurerm_api_management_backend" "books" {
  name                = "books"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "https://${azurerm_container_app.books.ingress[0].fqdn}/api"
}


resource "azurerm_api_management_api_policy" "books" {
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="books" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_api_operation" "create_book" {
  operation_id        = "createBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "createBook"
  method              = "POST"
  url_template        = "/books"
  description         = <<EOF
Creates a new book entry in the database from the HTTP request data.

This function is triggered by an HTTP POST request. It expects a JSON payload
with the book's details, validates the data using the Book model, and then
saves the new book document to Cosmos DB. If the data is invalid or the request
cannot be processed, it returns an appropriate HTTP response.
EOF

  request {
    description = <<EOF
Represents a book with properties to store in a database.

Attributes:
    id (str): Unique identifier for the book, automatically generated.
    title (str): The title of the book.
    author (str): The author of the book.
    isbn (str, optional): The International Standard Book Number of the book. Defaults to None.
    publishedDate (str, optional): The publication date of the book. Defaults to None.
    genre (str, optional): The genre of the book. Defaults to None.
EOF

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "title": "Example Book Title",
  "author": "John Doe",
  "isbn": "978-3-16-148410-0",
  "publishedDate": "2023-10-01",
  "genre": "Fiction"
}
EOF
      }
    }
  }

  response {
    status_code = 201
    description = "The book was successfully created."

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "title": "Example Book Title",
  "author": "John Doe",
  "isbn": "978-3-16-148410-0",
  "publishedDate": "2023-10-01",
  "genre": "Fiction"
}
EOF
      }
    }
  }
}

resource "azurerm_api_management_api_operation" "get_books" {
  operation_id        = "getBooks"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "getBooks"
  method              = "GET"
  url_template        = "/books"
  description         = <<EOF
Retrieves all book entries from the database.

This function is triggered by an HTTP GET request. It retrieves all book
documents from the Cosmos DB container and returns them as a list. If there
are no books in the database, it returns an empty list.
EOF

  response {
    status_code = 200
    description = "A list of book documents."

    representation {
      content_type = "application/json"

      example {
        name  = "books"
        value = <<EOF
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "title": "Example Book Title",
    "author": "John Doe",
    "isbn": "978-3-16-148410-0",
    "publishedDate": "2023-10-01",
    "genre": "Fiction"
  }
]
EOF
      }
    }
  }
}

resource "azurerm_api_management_api_operation" "get_book" {
  operation_id        = "getBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "getBook"
  method              = "GET"
  url_template        = "/books/{id}"
  description         = <<EOF
Retrieves a specific book entry from the database.

This function is triggered by an HTTP GET request with a book ID parameter.
It retrieves the book document with the specified ID from the Cosmos DB
container and returns it. If the book is not found, it returns an HTTP 404
response.
EOF

  template_parameter {
    name        = "id"
    type        = "string"
    required    = true
    description = "The unique identifier of the book to retrieve."

    example {
      name  = "id"
      value = "123e4567-e89b-12d3-a456-426614174000"
    }
  }

  response {
    status_code = 200
    description = "The book document with the specified ID."

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "title": "Example Book Title",
  "author": "John Doe",
  "isbn": "978-3-16-148410-0",
  "publishedDate": "2023-10-01",
  "genre": "Fiction"
}
EOF
      }
    }
  }

  response {
    status_code = 404
    description = "Book not found."
  }
}

resource "azurerm_api_management_api_operation" "update_book" {
  operation_id        = "updateBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "updateBook"
  method              = "PUT"
  url_template        = "/books/{id}"
  description         = <<EOF
Updates a specific book entry in the database.

This function is triggered by an HTTP PUT request with a book ID parameter
and a JSON payload containing the updated book data. It validates the data
using the UpdateBook model and then updates the book document in the Cosmos
DB container. If the book is not found or the data is invalid, it returns
an appropriate HTTP response.
EOF

  request {
    description = <<EOF
Represents the schema for updating a book's information.

Attributes:
    title (str): The title of the book. Optional.
    author (str): The author of the book. Optional.
    isbn (str): The International Standard Book Number of the book. Optional.
    publishedDate (str): The publication date of the book. Optional.
    genre (str): The genre of the book. Optional.
EOF

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "title": "Changed Book Title"
}
EOF
      }
    }
  }

  template_parameter {
    name        = "id"
    type        = "string"
    required    = true
    description = "The unique identifier of the book to retrieve."

    example {
      name  = "id"
      value = "123e4567-e89b-12d3-a456-426614174000"
    }
  }

  response {
    status_code = 200
    description = "The updated book document."

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "title": "Updated Book Title",
  "author": "Jane Doe",
  "isbn": "978-3-16-148410-1",
  "publishedDate": "2023-11-01",
  "genre": "Non-Fiction"
}
EOF
      }
    }
  }

  response {
    status_code = 404
    description = "Book not found."
  }
}

resource "azurerm_api_management_api_operation" "delete_book" {
  operation_id        = "deleteBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "deleteBook"
  method              = "DELETE"
  url_template        = "/books/{id}"
  description         = <<EOF
Deletes a specific book entry from the database.

This function is triggered by an HTTP DELETE request with a book ID parameter.
It deletes the book document with the specified ID from the Cosmos DB container.
If the book is not found, it returns an HTTP 404 response.
EOF

  template_parameter {
    name        = "id"
    type        = "string"
    required    = true
    description = "The unique identifier of the book to retrieve."

    example {
      name  = "id"
      value = "123e4567-e89b-12d3-a456-426614174000"
    }
  }

  response {
    status_code = 204
    description = "The book was successfully deleted."
  }

  response {
    status_code = 404
    description = "Book not found."
  }
}
