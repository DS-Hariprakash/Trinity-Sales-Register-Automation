# Trinity Sales Register — Automated Email Report
## Setup & Usage Guide

This project downloads the **Sales Register Mattresses** report from the
Ramco ERP and emails the exported `.xlsx` file **as-is** (no editing,
no breakup, no WhatsApp) to the configured recipients. It mirrors the
Sales Register download flow but replaces the WhatsApp step with email
(using the OEE project's SMTP approach).

---

### STEP 1 — Install Python dependencies

Open Command Prompt in this folder and run:

    pip install -r requirements.txt
    playwright install chrome

(playwright + python-dotenv + openpyxl are required.)

---

### STEP 2 — Verify config.env

Open `config.env` and confirm:

  ERP_URL        = https://peps.ramcoes.com/RVW/hub/index.html
  ERP_USERNAME   = PEPS69            (RAMCO login id)
  ERP_PASSWORD   = Peps@131          (RAMCO password)
  DOWNLOAD_DIR   = C:\Users\ADMIN\Downloads

  SMTP_SERVER    = zimsmtp.logix.in
  SMTP_PORT      = 587
  SMTP_USER      = pepsit@pepsindia.com
  SMTP_PASSWORD  = Peps@151
  EMAIL_RECIPIENTS = trinity@pepsindia.com
  EMAIL_CC      = hariit@pepsindia.com,sales@pepsindia.com,
                  janaki@pepsindia.com,itsupport@pepsindia.com

  HEADLESS       = True   (unattended 7 AM runs; set False to watch)

Change nothing else unless you move to a different environment.

---

### STEP 3 — Run manually (first test)

Double-click `run_task.bat`  OR  run in terminal:

    python automate_report.py     # downloads the report
    python email_sender.py        # emails the latest downloaded file

To send a **test email to one person only** (no CC leak):

    python email_sender.py --to hariit@pepsindia.com --cc=

---

### STEP 4 — Schedule daily at 7:00 AM (Windows Task Scheduler)

Right-click `register_task.bat` and choose **Run as administrator**.
This creates a daily 07:00 task named "Trinity Sales Register Email"
that runs `run_task.bat` under the SYSTEM account (works even when no
user is logged on).

Verify with:

    schtasks /Query /TN "Trinity Sales Register Email"

To remove later:

    schtasks /Delete /TN "Trinity Sales Register Email" /F

---

### WHAT IT DOES

1. `automate_report.py` logs into Ramco ERP, opens the
   "Sales Register Mattresses" report, exports the **current month**
   range to an `.xlsx` in DOWNLOAD_DIR, and fixes the ERP's broken
   xlsx relationship paths so Excel can open it.
2. `email_sender.py` attaches that file to an email (unchanged) and
   sends it via SMTP to EMAIL_RECIPIENTS (CC: EMAIL_CC).

`run_task.bat` retries the download up to 6 times (the ERP login is
flaky at odd hours), then sends the email. All output goes to
`run_log.txt`.

---

### NOTES / KNOWN LIMITATIONS

- The exported file is emailed exactly as downloaded — no filtering or
  re-formatting (unlike the Sales Register WhatsApp breakup).
- If Ramco updates its UI/selectors, the navigation code in
  `automate_report.py` may need adjustment.
- DURATION_LOG_FILE is optional; if set, the run time is also logged to
  the Sales Register duration workbook.
- Large monthly reports can be ~14 MB; the mail server accepted this
  size in testing, but very large months could approach attachment
  limits.
