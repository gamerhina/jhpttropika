# Google Scholar Citation by Bihikmi
Version : 1.0.0
Target : OJS 3.4.x
PHP : >= 8.1
Database : MySQL
License : GPL v3

---

# PROJECT OVERVIEW

Develop a production-ready OJS Generic Plugin named:

Scholar Citation Widget

The plugin displays Google Scholar metrics inside the journal website.

The plugin MUST be installable directly from OJS.

The plugin MUST follow OJS 3.4 plugin architecture.

The plugin MUST NOT directly scrape Google Scholar.

---

# IMPORTANT ARCHITECTURE (MANDATORY)

THIS PROJECT CONSISTS OF TWO SEPARATE APPLICATIONS.

Application 1

ScholarUpdater

Language

Python

Responsibility

Collect Google Scholar data.

Output

citations.json

Runs

Cron
Task Scheduler
GitHub Action
Docker

------------------------------------

Application 2

ScholarCitationWidget

Language

PHP

Responsibility

Display citation information.

Never scrape Google Scholar.

Never execute Python.

Never execute Selenium.

Never call shell_exec().

Only read citations.json.

------------------------------------

Architecture

Google Scholar

↓

ScholarUpdater (Python)

↓

citations.json

↓

Scholar Citation Widget (PHP)

↓

Chart.js

↓

Sidebar / Homepage

---

# WHY THIS ARCHITECTURE

Google Scholar

• No official API

• Frequently changes HTML

• Frequently blocks scraping

Shared Hosting

• No Selenium

• No Chrome

• No Playwright

Therefore

Python performs scraping.

Plugin performs display only.

---

# REPOSITORY STRUCTURE

Repository

ScholarCitationWidget/

│

├── updater/

│   ├── updater.py

│   ├── requirements.txt

│   ├── parser.py

│   ├── config.py

│   ├── logger.py

│   ├── output.py

│   └── citations.json

│

└── plugin/

    └── scholarCitationWidget/

        ├── index.php

        ├── version.xml

        ├── ScholarCitationWidgetPlugin.php

        ├── classes/

        ├── templates/

        ├── css/

        ├── js/

        ├── cache/

        ├── locale/

        └── README.md

---

# PYTHON UPDATER SPECIFICATION

Purpose

Retrieve Google Scholar information.

Input

Scholar ID

Example

zCyDRywAAAAJ

Output

citations.json

Update Frequency

Configurable

Default

24 hours

Parser

BeautifulSoup

Fallback

Selenium

If BeautifulSoup fails

↓

Use Selenium

↓

Generate citations.json

---

# PYTHON OUTPUT FORMAT

{
    "profile":{
        "name":"",
        "scholarId":"",
        "url":""
    },

    "metrics":{
        "citations":0,
        "hindex":0,
        "i10index":0
    },

    "chart":[

        {
            "year":2018,
            "citations":3
        }

    ],

    "updated":"",

    "generator":"ScholarUpdater"
}

---

# OJS PLUGIN RESPONSIBILITY

Read citations.json

Render cards

Render chart

Render button

Render update time

Nothing else.

---

# OJS PLUGIN FEATURES

Display

✓ Total Citation

✓ h-index

✓ i10-index

✓ Last Update

✓ Google Scholar Button

✓ Citation Trend Graph

Responsive

Bootstrap compatible

Dark mode compatible

---

# SETTINGS PAGE

Location

Website

↓

Plugins

↓

Scholar Citation Widget

↓

Settings

Fields

Scholar ID

Cache Hours

JSON File Location

Auto Refresh

Sidebar Title

Theme Color

Show Button

Show Graph

Save

---

# DEFAULT SETTINGS

Scholar ID

Empty

Cache

24

Sidebar Title

Google Scholar

Theme

Bootstrap

---

# CACHE SYSTEM

Plugin reads

cache/citations.json

If missing

↓

Show

"No citation data available."

If invalid

↓

Show

"Invalid citation file."

Never crash OJS.

---

# SIDEBAR LAYOUT

+--------------------------------------+

Google Scholar

----------------------------------------

Total Citation

1258

----------------------------------------

h-index

19

----------------------------------------

i10-index

31

----------------------------------------

Line Chart

----------------------------------------

Updated

2026-07-20

----------------------------------------

View Google Scholar

+--------------------------------------+

---

# HOMEPAGE HOOK

Plugin supports

Sidebar

Homepage

Custom Block

Widget

---

# CHART

Library

Chart.js

Type

Line Chart

Features

Responsive

Animation

Tooltip

Dark mode

No jQuery

---

# BUTTON

Open

https://scholar.google.com/citations?user=ID

Open new tab.

---

# PHP DIRECTORY

plugin/

index.php

version.xml

ScholarCitationWidgetPlugin.php

classes/

ApiHandler.php

Cache.php

SettingsDAO.php

Widget.php

JsonReader.php

templates/

sidebar.tpl

settings.tpl

css/

widget.css

js/

widget.js

chart.min.js

cache/

citations.json

locale/

en/

id/

README.md

---

# DEVELOPMENT ROADMAP

PHASE 1

Plugin Skeleton

Deliverable

Installable plugin.

----------------------------------------

PHASE 2

Sidebar Hook

Deliverable

Widget appears.

----------------------------------------

PHASE 3

Settings

Deliverable

Configuration page.

----------------------------------------

PHASE 4

JSON Reader

Deliverable

Read citations.json.

----------------------------------------

PHASE 5

Cache Validation

Deliverable

Handle missing or corrupted JSON.

----------------------------------------

PHASE 6

Cards

Deliverable

Citation

h-index

i10-index

----------------------------------------

PHASE 7

Chart.js

Deliverable

Animated citation graph.

----------------------------------------

PHASE 8

Responsive Design

Deliverable

Desktop

Tablet

Mobile

----------------------------------------

PHASE 9

Theme Integration

Deliverable

Bootstrap

Dark mode

----------------------------------------

PHASE 10

Packaging

Deliverable

ZIP installer

README

Documentation

Versioning

---

# CODING STANDARD

PSR-12

PHP 8.1

OJS 3.4 API

Smarty

Bootstrap

Chart.js

Vanilla JavaScript

No jQuery

No inline JS

No inline CSS

---

# SECURITY

Escape HTML

Validate JSON

Validate Scholar ID

CSRF protection

No eval()

No shell_exec()

No exec()

No Python execution

No external command execution

---

# PERFORMANCE

Never scrape Google Scholar from PHP.

Always read local JSON.

Maximum one JSON read per request.

Cache all rendered data.

---

# ERROR HANDLING

If JSON missing

↓

Display warning.

If JSON invalid

↓

Display warning.

If chart data empty

↓

Hide chart.

Never generate PHP Fatal Error.

---

# FINAL DELIVERABLE

Deliver a complete production-ready package.

The package must include:

1. Python ScholarUpdater

2. OJS 3.4 Plugin

3. Sample citations.json

4. README.md

5. Installation Guide

6. Configuration Guide

7. User Manual

8. Ready-to-install ZIP

No placeholders.

No TODO.

No pseudo-code.

Every file must be fully implemented.

The final result must be directly installable on OJS 3.4 without requiring additional coding.