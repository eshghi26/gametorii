# Use the official PostgreSQL image as the base image
FROM postgres:15

# Set environment variables for the database
ENV POSTGRES_DB=gamedb
ENV POSTGRES_USER=gameuser
ENV POSTGRES_PASSWORD=gamepassword

# Copy any initialization SQL scripts if needed (optional)
# Uncomment the following lines if you have an init script
# COPY ./init.sql /docker-entrypoint-initdb.d/
# Copy custom configuration files
COPY ./postgresql.conf /etc/postgresql/13/main/postgresql.conf
COPY ./pg_hba.conf /etc/postgresql/13/main/pg_hba.conf
# Expose the PostgreSQL port
EXPOSE 5432
