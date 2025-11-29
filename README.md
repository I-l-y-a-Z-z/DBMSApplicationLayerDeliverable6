# MNHS Manager

### Lab 6 Application Layer - Database Management Systems (DBMS)

A comprehensive **Hospital Management System Dashboard** built with Python and Streamlit. This application was developed as a practical implementation for Lab 6, demonstrating the integration of a relational database (MySQL) with a modern frontend interface to streamline clinical operations.

![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=Streamlit&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Plotly](https://img.shields.io/badge/Plotly-239120?style=for-the-badge&logo=plotly&logoColor=white)

**🚀 Live Demo:** [mnhslab6.streamlit.app](https://mnhslab6.streamlit.app)

## Key Features

1.  **Patient Directory**:
    * View and sort registered patients from the database.
    * Optimized SQL queries for efficient data retrieval.
2.  **Add Patient**:
    * **Streamlined Registration**: A dedicated "Personal Information" interface to onboard new patients efficiently.
    * **Automated ID**: The system automatically generates a unique `Patient ID` (read-only) to ensure database integrity.
    * **Demographic Data**: Captures essential mandatory fields including **CIN**, Full Name, Date of Birth, and Sex.
    * **Extended Profile**: Allows for optional entry of contact details (Phone, Email) and medical context (Blood Group).
3.  **Smart Appointment Scheduling**:
    * **Cascading Dropdowns:** Select Hospital -> Filter Departments -> Filter Staff.
    * **Transaction Management:** Ensures data integrity when creating Clinical Activities and Appointments simultaneously.
    * Auto-generated Clinical Activity IDs.
4.  **Inventory Status**:
    * Real-time **Low Stock Alerts** based on reorder levels.
    * Visual breakdown of critical vs. adequate stock levels.
    * Data joined across Medication, Stock, and Hospital tables.
5.  **Staff Analytics**:
    * Complex nested queries to calculate workload distribution.
    * **Grouped Bar Charts** to show staff performance across multiple hospital facilities using Plotly.

## Tech Stack

* **Frontend:** [Streamlit](https://streamlit.io/) (Dark Mode / Sobriety Theme)
* **Database:** MySQL (Compatible with TiDB Cloud, Aiven, or Localhost)
* **Data Processing:** Pandas
* **Visualization:** Plotly Express & Graph Objects
* **Environment Management:** Python-dotenv

## Installation & Local Setup

Follow these steps to run the application on your local machine.

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/mnhs-manager.git
cd mnhs-manager
```


### 2. Set Up Virtual Environment

# Windows

```bash
python -m venv mnhsapp
.\mnhsapp\Scripts\activate
```


# Mac/Linux

```bash
python3 -m venv mnhsapp
source mnhsapp/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables
Create a file named .env in the root directory and add your database credentials:

```bash
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DB=mnhs_db
MYSQL_USER=your_user
MYSQL_PASSWORD=your_password
```

### 5. Database Setup

The repository includes a monolithic SQL script named `query.sql`. This file contains the **Data Definition Language (DDL)** to build the schema and the **Data Manipulation Language (DML)** to populate it with a comprehensive, hyper-realistic dataset.

Follow these steps to initialize the database using **MySQL Workbench**:

1.  **Launch MySQL Workbench** and connect to your local MySQL instance (usually `root` on `localhost:3306`).
2.  In the top menu, go to **File** > **Open SQL Script...** (or press `Ctrl+Shift+O`).
3.  Navigate to the project folder and select the `query.sql` file.
4.  Once the script loads in the editor, click the **Execute** button (the **lightning bolt icon** ⚡) located in the toolbar above the script code to run the entire file.
5.  **Wait for execution:** The script will drop any existing version of the `MNHS` database, recreate the tables, and insert all sample data. Check the "Output" panel at the bottom to ensure all commands finished successfully.
6.  In the **Navigator** panel on the left (under the "Schemas" tab), click the **Refresh** button (small circular arrows).
7.  Verify that the `MNHS` database now appears in the list.

> **Important:** The `query.sql` script creates the schema and data, but it does **not** create the database user automatically. You must manually create a database user (or use an existing one) and ensure that the username and password match exactly what you added to your `.env` file (as explained in the Configuration section above).

### 6. Run the App

```bash
streamlit run main.py
```

## Cloud Deployment (Streamlit Cloud)

To deploy this app live:

1.  Push this code to **GitHub**.
2.  Go to **[share.streamlit.io](https://share.streamlit.io/)**.
3.  Deploy the app using `main.py` as the entry point.
4.  In the **Advanced Settings** -> **Secrets** section, add your cloud database config:

```bash
[mysql]
host = "gateway01.us-west-2.prod.aws.tidbcloud.com"
port = 4000
database = "mnhs_db"
user = "your_tidb_user"
password = "your_tidb_password"
```

## 👥 Authors

This project was built by:

* **Ilyas Rahmouni**
* **Younes Lougnidi**
* **Malak Koulat**
* **Aymane Raiss**
* **Youness Latif**
* **Rayane Khaldi**
* **Zakaria Harira**

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
