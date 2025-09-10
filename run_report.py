import os, csv
from datetime import date, timedelta
from dotenv import load_dotenv
import mysql.connector as mysql

load_dotenv()

CFG = dict(
    host=os.getenv("DB_HOST", "127.0.0.1"),
    port=int(os.getenv("DB_PORT", "3306")),
    user=os.getenv("DB_USER", "root"),
    password=os.getenv("DB_PASSWORD", ""),
    database=os.getenv("DB_NAME", "little_lemon"),
    pool_name=os.getenv("POOL_NAME", "lemon_pool"),
    pool_size=int(os.getenv("POOL_SIZE", "5")),
)

def get_conn():
    return mysql.connect(
        host=CFG["host"],
        port=CFG["port"],
        user=CFG["user"],
        password=CFG["password"],
        database=CFG["database"],
        pool_name=CFG["pool_name"],
        pool_size=CFG["pool_size"],
    )

def export_resultset_to_csv(cursor, filename):
    cols = [d[0] for d in cursor.description]
    with open(filename, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(cols)
        for row in cursor:
            writer.writerow(row)

def run_report(start_date: date, end_date: date):
    conn = get_conn()
    cur = conn.cursor()
    # استدعاء الإجراء
    cur.callproc("sp_sales_report", (start_date, end_date))

    # MySQL يعيد عدة result sets: نمرّ عليها بالترتيب ونصدرها
    result_files = ["daily_summary.csv", "top_items.csv", "by_category.csv", "kpis.csv"]
    for idx, result in enumerate(cur.stored_results()):
        fname = result_files[idx]
        export_resultset_to_csv(result, fname)
        print(f"[OK] wrote {fname}")

    cur.close()
    conn.close()

if __name__ == "__main__":
    # افتراض: تقرير آخر 14 يوماً
    end_d = date.today()
    start_d = end_d - timedelta(days=13)
    print(f"Generating report from {start_d} to {end_d} ...")
    run_report(start_d, end_d)
    print("Done.")
