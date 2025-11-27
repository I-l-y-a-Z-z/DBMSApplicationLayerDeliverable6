import streamlit as st
import pandas as pd
import mysql.connector
import os
import plotly.express as px
import plotly.graph_objects as go
from dotenv import load_dotenv

# 1. SETUP & CONFIGURATION
load_dotenv()

# Local .env configuration
cfg = dict(
    host=os.getenv("MYSQL_HOST"),
    port=int(os.getenv("MYSQL_PORT", 3306)),
    database=os.getenv("MYSQL_DB"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
)

def get_connection():
    """
    Establishes a connection to the database.
    Prioritizes Streamlit Secrets (Cloud), falls back to .env (Local).
    """
    try:
        # Check if secrets exist without crashing
        if "mysql" in st.secrets:
            return mysql.connector.connect(
                host=st.secrets["mysql"]["host"],
                port=st.secrets["mysql"]["port"],
                user=st.secrets["mysql"]["user"],
                password=st.secrets["mysql"]["password"],
                database=st.secrets["mysql"]["database"]
            )
    except Exception:
        pass
        
    # Fallback to local .env configuration defined in 'cfg'
    return mysql.connector.connect(**cfg)

# 2. DATABASE FUNCTIONS

def list_patients_ordered_by_last_name(limit=20):
    sql = """
    SELECT IID, CIN, FullName, Birth, Sex, BloodGroup, Phone, Email
    FROM Patient
    ORDER BY SUBSTRING_INDEX(FullName, ' ', -1)
    LIMIT %s
    """
    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql, (limit,))
                return cur.fetchall()
    except Exception as e:
        st.error(f"Error fetching patients: {e}")
        return []

# --- DROPDOWN HELPERS ---
def get_all_patients():
    sql = "SELECT IID, FullName, CIN FROM Patient ORDER BY FullName"
    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql)
                return cur.fetchall()
    except: return []

def get_all_hospitals():
    sql = "SELECT HID, Name FROM Hospital ORDER BY Name"
    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql)
                return cur.fetchall()
    except: return []

def get_departments_by_hospital(hid):
    sql = "SELECT DEP_ID, Name FROM Department WHERE HID = %s ORDER BY Name"
    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql, (hid,))
                return cur.fetchall()
    except: return []

def get_all_staff():
    sql = "SELECT STAFF_ID, FullName FROM Staff ORDER BY FullName"
    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql)
                return cur.fetchall()
    except: return []

def get_next_caid():
    sql = "SELECT MAX(CAID) as max_id FROM ClinicalActivity"
    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql)
                res = cur.fetchone()
                if res and res['max_id']:
                    return res['max_id'] + 1
                return 1000 
    except: return 1000

# --------------------------

def schedule_appointment(caid, iid, staff_id, dep_id, date_str, time_str, reason):
    sql_activity = """
    INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    sql_appt = """
    INSERT INTO Appointment (CAID, Reason, Status)
    VALUES (%s, %s, 'Scheduled')
    """
    with get_connection() as cnx:
        try:
            with cnx.cursor() as cur:
                cur.execute(sql_activity, (caid, iid, staff_id, dep_id, date_str, time_str))
                cur.execute(sql_appt, (caid, reason))
                cnx.commit()
                return True
        except Exception as e:
            cnx.rollback()
            raise e

def get_low_stock_report():
    sql = """
    SELECT 
    M.Name AS MedicationName,
    H.Name AS HospitalName,
    COALESCE(S.Qty, 0) AS CurrentQuantity,
    COALESCE(S.ReorderLevel, 0) AS ReorderLevel,
    CASE 
        WHEN S.Qty IS NULL THEN 'No Stock'
        WHEN S.Qty < S.ReorderLevel THEN 'Low Stock'
        ELSE 'Adequate'
    END AS StockStatus
    FROM Medication M
    CROSS JOIN Hospital H
    LEFT JOIN Stock S ON M.DrugID = S.DrugID AND H.HID = S.HID
    WHERE S.Qty IS NULL OR S.Qty < S.ReorderLevel
    ORDER BY M.Name, H.Name;
    """
    try:
        conn = get_connection()
        df = pd.read_sql(sql, conn)
        conn.close()
        return df
    except Exception as e:
        st.error(f"Error generating stock report: {e}")
        return None

def get_staff_workload_share():
    sql = """
    SELECT 
    s.STAFF_ID,
    s.FullName AS StaffName,
    h.Name AS HospitalName,
    s.StaffApp AS TotalAppointments,
    ROUND((s.StaffApp / h.HospitalApp) * 100, 2) AS PercentageShare
    FROM (
        SELECT ca.STAFF_ID, st.FullName, dep.HID, COUNT(a.CAID) AS StaffApp
        FROM Appointment a
        JOIN ClinicalActivity ca ON a.CAID = ca.CAID
        JOIN Staff st ON ca.STAFF_ID = st.STAFF_ID
        JOIN Department dep ON ca.DEP_ID = dep.DEP_ID
        GROUP BY ca.STAFF_ID, st.FullName, dep.HID
    ) s
    JOIN (
        SELECT dep.HID, Hosp.Name, COUNT(a.CAID) AS HospitalApp
        FROM Appointment a
        JOIN ClinicalActivity ca ON ca.CAID = a.CAID
        JOIN Department dep ON ca.DEP_ID = dep.DEP_ID
        JOIN Hospital Hosp ON dep.HID = Hosp.HID
        GROUP BY dep.HID, Hosp.Name
    ) h ON s.HID = h.HID
    ORDER BY h.HID, PercentageShare DESC;
    """
    try:
        conn = get_connection()
        df = pd.read_sql(sql, conn)
        conn.close()
        return df
    except Exception as e:
        st.error(f"Error calculating workload: {e}")
        return None

# 3. UI & VISUALIZATION

def main():
    st.set_page_config(
        page_title="MNHS Manager",
        layout="wide",
        initial_sidebar_state="expanded"
    )

    # --- DARK MODE CSS ---
    st.markdown("""
        <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap');

        /* 1. Base App Styling */
        .stApp {
            background-color: #0F172A !important;
            font-family: 'Inter', sans-serif !important;
        }
        
        /* 2. Text Color Overrides */
        h1, h2, h3, h4, h5, h6, p, label, li, .stMarkdown {
            color: #F8FAFC !important;
        }
        
        .sub-text {
            color: #94A3B8 !important;
        }

        /* 3. Sidebar Styling */
        [data-testid="stSidebar"] {
            background-color: #020617 !important;
            border-right: 1px solid #1E293B;
        }
        [data-testid="stSidebar"] p, [data-testid="stSidebar"] span, [data-testid="stSidebar"] label {
            color: #F8FAFC !important;
        }

        /* 4. Inputs & Widgets */
        .stTextInput input, .stNumberInput input, .stDateInput input, .stTimeInput input, .stTextArea textarea {
            background-color: #1E293B !important; 
            color: #F8FAFC !important;
            border: 1px solid #334155 !important;
        }
        .stSelectbox div[data-baseweb="select"] > div {
             background-color: #1E293B !important;
             color: #F8FAFC !important;
             border: 1px solid #334155 !important;
        }
        ul[data-testid="stSelectboxVirtualDropdown"] li {
            background-color: #1E293B !important;
            color: white !important;
        }
        
        /* 5. Buttons */
        .stButton > button {
            background-color: #1E293B !important;
            color: #F8FAFC !important;
            border: 1px solid #475569 !important;
            border-radius: 8px;
        }
        .stButton > button:hover {
            border-color: #94A3B8 !important;
            background-color: #334155 !important;
        }
        .stForm [kind="primary"] {
            background-color: #334155 !important;
            border: 1px solid #475569 !important;
        }

        /* 6. Metrics & Dataframe */
        [data-testid="stMetricValue"] { color: #F8FAFC !important; }
        [data-testid="stMetricLabel"] { color: #94A3B8 !important; }
        [data-testid="stDataFrame"] { border: 1px solid #334155; }
        </style>
    """, unsafe_allow_html=True)

    # --- HEADER ---
    st.markdown("<h1>MNHS Manager</h1>", unsafe_allow_html=True)
    st.markdown("<p class='sub-text' style='margin-top: -10px; margin-bottom: 30px;'>Clinical Operations & Analytics Dashboard</p>", unsafe_allow_html=True)

    # --- SIDEBAR ---
    st.sidebar.markdown("### Navigation")
    menu_options = [
        "Patient Directory",
        "Schedule Appointment",
        "Inventory Status",
        "Staff Analytics"
    ]
    choice = st.sidebar.radio("Go to", menu_options, label_visibility="collapsed")

    # --- 1. PATIENT DIRECTORY ---
    if choice == "Patient Directory":
        col1, col2 = st.columns([4, 1])
        with col1:
            st.markdown("### Patient Directory")
            st.markdown("<p class='sub-text' style='font-size:0.9rem'>View and filter registered patients.</p>", unsafe_allow_html=True)
        with col2:
            limit = st.number_input("Limit rows", 5, 100, 20)
        
        if st.button("Load Data"):
            with st.spinner("Fetching..."):
                results = list_patients_ordered_by_last_name(limit)
                if results:
                    df = pd.DataFrame(results)
                    st.dataframe(df, use_container_width=True, hide_index=True)
                else:
                    st.info("No records found.")

    # --- 2. SCHEDULE APPOINTMENT ---
    elif choice == "Schedule Appointment":
        st.markdown("### New Appointment")
        st.markdown("<p class='sub-text' style='font-size:0.9rem'>Select the details below to schedule a visit.</p>", unsafe_allow_html=True)
        
        all_patients = get_all_patients()
        all_hospitals = get_all_hospitals()
        all_staff = get_all_staff()
        next_caid = get_next_caid()

        if not all_patients or not all_hospitals:
            st.error("Data missing. Please ensure database is seeded.")
            return

        # DROPDOWNS
        patient_options = {f"{p['FullName']} (CIN: {p['CIN']})": p['IID'] for p in all_patients}
        selected_patient_label = st.selectbox("Select Patient", options=list(patient_options.keys()))
        selected_iid = patient_options[selected_patient_label]

        col_fac, col_dept, col_staff = st.columns(3)
        
        with col_fac:
            hospital_options = {h['Name']: h['HID'] for h in all_hospitals}
            selected_hospital_label = st.selectbox("Select Hospital", options=list(hospital_options.keys()))
            selected_hid = hospital_options[selected_hospital_label]

        with col_dept:
            dept_data = get_departments_by_hospital(selected_hid)
            if dept_data:
                dept_options = {d['Name']: d['DEP_ID'] for d in dept_data}
                selected_dept_label = st.selectbox("Select Department", options=list(dept_options.keys()))
                selected_dep_id = dept_options[selected_dept_label]
            else:
                st.warning("No departments found.")
                selected_dep_id = None

        with col_staff:
            staff_options = {s['FullName']: s['STAFF_ID'] for s in all_staff}
            selected_staff_label = st.selectbox("Select Staff", options=list(staff_options.keys()))
            selected_staff_id = staff_options[selected_staff_label]

        st.markdown("---")

        with st.form("appt_form"):
            st.markdown("#### Appointment Details")
            c1, c2, c3 = st.columns(3)
            with c1:
                st.text_input("New Activity ID (Auto)", value=next_caid, disabled=True)
            with c2:
                date = st.date_input("Date")
            with c3:
                time = st.time_input("Time")
            
            reason = st.text_area("Reason for visit", height=100)
            submitted = st.form_submit_button("Confirm Schedule", type="primary", use_container_width=True)
            
            if submitted:
                if selected_dep_id is None:
                    st.error("Invalid Department.")
                else:
                    try:
                        schedule_appointment(next_caid, selected_iid, selected_staff_id, selected_dep_id, str(date), str(time), reason)
                        st.success(f"Appointment scheduled (ID: {next_caid})")
                    except Exception as e:
                        st.error(f"Failed to schedule: {e}")

    # --- 3. INVENTORY STATUS ---
    elif choice == "Inventory Status":
        st.markdown("### Low Stock Alert")
        df = get_low_stock_report()
        
        if df is not None and not df.empty:
            m1, m2, m3 = st.columns(3)
            no_stock = len(df[df['StockStatus'] == 'No Stock'])
            low_stock = len(df[df['StockStatus'] == 'Low Stock'])
            m1.metric("Critical", no_stock)
            m2.metric("Warning", low_stock)
            m3.metric("Total Flagged", len(df))
            
            st.divider()
            
            c_chart, c_data = st.columns([1, 2])
            with c_chart:
                status_counts = df['StockStatus'].value_counts()
                fig = px.pie(
                    values=status_counts.values,
                    names=status_counts.index,
                    hole=0.6,
                    color_discrete_sequence=['#ef4444', '#f59e0b', '#475569'],
                    template="plotly_dark"
                )
                fig.update_layout(
                    showlegend=False,
                    margin=dict(t=0, b=0, l=0, r=0),
                    height=200,
                    paper_bgcolor='rgba(0,0,0,0)',
                    plot_bgcolor='rgba(0,0,0,0)',
                    annotations=[dict(text='Stock', x=0.5, y=0.5, font_size=14, showarrow=False, font=dict(color='#F8FAFC'))]
                )
                st.plotly_chart(fig, use_container_width=True)
            
            with c_data:
                def style_status(val):
                    color = '#ef4444' if val == 'No Stock' else '#f59e0b' if val == 'Low Stock' else '#94A3B8'
                    return f'color: {color}; font-weight: 500'
                st.dataframe(df.style.applymap(style_status, subset=['StockStatus']), use_container_width=True, height=250)
        else:
            st.success("All inventory levels are optimal.")

    # --- 4. STAFF ANALYTICS ---
    elif choice == "Staff Analytics":
        st.markdown("### Workload Distribution")
        
        df = get_staff_workload_share()
        
        if df is not None and not df.empty:
            df = df.sort_values(by='PercentageShare', ascending=True)
            
            # Using px.bar with barmode='group' prevents overlapping.
            fig = px.bar(
                df,
                x="PercentageShare",
                y="StaffName",
                color="HospitalName", 
                orientation='h',
                barmode='group',      
                text="PercentageShare",
                color_discrete_sequence=['#3b82f6', '#10b981', '#f59e0b', '#ef4444'],
                labels={"PercentageShare": "Share (%)", "StaffName": "Staff Member", "HospitalName": "Facility"}
            )
            
            fig.update_traces(texttemplate='%{text:.1f}%', textposition='outside')
            fig.update_layout(
                title="",
                xaxis_title="Share of Hospital Appointments",
                template="plotly_dark",
                height=500,
                margin=dict(l=0, r=0, t=0, b=0),
                paper_bgcolor='rgba(0,0,0,0)',
                plot_bgcolor='rgba(0,0,0,0)',
                font=dict(color='#F8FAFC'),
                xaxis=dict(showgrid=False),
                yaxis=dict(showgrid=False),
                legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
            )
            
            st.plotly_chart(fig, use_container_width=True)
            
            with st.expander("View Raw Data Table"):
                st.dataframe(df, use_container_width=True)
        else:
            st.info("No workload data available.")

    # --- FOOTER ---
    st.markdown("---")
    st.markdown(
        """
        <div style="text-align: center; color: #94A3B8; font-size: 0.875rem;">
            Made by Ilyas Rahmouni, Younes Lougnidi, Malak Koulat, Aymane Raiss, Youness Latif, Rayane Khaldi, Zakaria Harira
        </div>
        """,
        unsafe_allow_html=True
    )

if __name__ == "__main__":
    main()
