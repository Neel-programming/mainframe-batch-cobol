# Monthly Account Interest Batch Job (COBOL + JCL)

A COBOL batch program that reads a fixed-width account file, applies
one month of interest to each account, and produces an updated
account file plus a summary report — the same basic pattern used in
real overnight banking batch jobs (interest posting, statement
generation, end-of-day settlement).

## What's real vs. what's illustrative — please read this part

This project is honest about what it does and doesn't include:

- **COBOL program (`src/ACCTPROC.CBL`)** — real, runnable code. You
  can compile and run it yourself with a free, open-source COBOL
  compiler (instructions below).
- **JCL (`jcl/RUNACCT.JCL`)** — written to be realistic and correctly
  structured, showing how this program would actually be submitted as
  a batch job on a real IBM mainframe (z/OS). It is **not executable**
  here or on a personal computer — real JCL only runs on a licensed
  z/OS system, which isn't something available outside an enterprise
  mainframe environment.
- **CICS, DB2, IMS, WMQ** — this project does **not** use these. They
  require licensed IBM software and a real mainframe. The program
  reads a plain flat file instead of a live DB2 table, and there's no
  CICS transaction or WMQ messaging involved. The "Architecture notes"
  section below explains conceptually how this program would connect
  to those pieces in a real bank environment, without claiming
  hands-on experience with them.

The honest version of this story: **COBOL and JCL fundamentals,
demonstrated with real code**, plus a clear-eyed understanding of
where CICS/DB2/IMS/WMQ would fit in — which is a reasonable, truthful
thing to bring up in an interview.

## How to run it

**1. Install GnuCOBOL** (a free, open-source COBOL compiler):
- **Mac:** `brew install gnu-cobol`
- **Ubuntu/Debian:** `sudo apt install gnucobol4` (or `gnucobol`)
- **Windows:** use WSL and follow the Ubuntu instructions, or install
  via [GnuCOBOL's official builds](https://gnucobol.sourceforge.io/)

Check it worked:

cobc --version


**2. Copy the sample data next to where you'll run the program:**

cp sample-data/ACCOUNTS.DAT src/
cd src


**3. Compile it:**

cobc -x -free ACCTPROC.CBL -o acctproc


**4. Run it:**

./acctproc


**5. Check the output:**

cat REPORT.TXT
cat UPDATED.DAT


There's also `src/ACCTPROC-TEST.CBL` — a self-contained version with
sample data built in and results printed to the screen, useful for a
fast sanity check in any online COBOL compiler without needing to
manage separate files.

## Sample data

`sample-data/ACCOUNTS.DAT` has 3 sample accounts in a fixed-width
layout (this stands in for what you'd get if you extracted rows from
a DB2 table into a flat file, which is a common step in real batch
processing):

| Field | Positions | Format |
|---|---|---|
| Account ID | 1–6 | 6-digit number |
| Name | 7–26 | 20 characters, space-padded |
| Balance | 27–35 | 9 digits, implied 2 decimal places |
| Interest rate | 36–39 | 4 digits, implied 3 decimal places |

## Architecture notes: how this fits into a real mainframe system

In an actual bank environment, this program would typically be one
step in a larger pipeline:

- **DB2** would hold the live account data. An earlier batch step
  (or a DB2 unload utility) would extract account rows into a flat
  file like `ACCOUNTS.DAT`, or the COBOL program would embed SQL
  directly to read DB2 tables instead of a flat file.
- **CICS** would handle the *online, real-time* side of banking (a
  teller or ATM transaction hitting an account) — separate from this
  *batch* program, which runs on a schedule (e.g., overnight) rather
  than in response to a live user action.
- **IMS** might be involved if some of the account or customer data
  lives in an older hierarchical database rather than DB2.
- **WMQ** would typically carry a message once this batch job
  finishes — for example, notifying a downstream system that updated
  balances are ready, or feeding a mobile/online banking platform.
- **JCL** is the layer that ties it together: scheduling the job,
  supplying the right datasets, and handling step-to-step flow.

## Built by

Neel Patel — [github.com/Neel-programming](https://github.com/Neel-programming)
