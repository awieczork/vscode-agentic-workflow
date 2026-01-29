# Tech Context: patterns-shiny-app

> **Updated:** 2026-01-28

---

## Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Language** | R | 4.4+ | Primary language |
| **Framework** | Shiny | 1.8+ | Web application framework |
| **UI** | bslib | 0.6+ | Bootstrap 5 theming |
| **Graphs** | visNetwork | 2.1+ | Interactive network visualization |
| **Tables** | reactable | 0.4+ | Interactive data tables |
| **DnD** | sortable | 0.5+ | Drag-and-drop for simulation |
| **Data** | arrow | 15+ | Parquet/Arrow dataset access |
| **Data** | data.table | 1.15+ | Fast in-memory operations |
| **Container** | Docker | 24+ | Deployment |
| **Base Image** | rocker/shiny-verse | 4.4 | R + Shiny + Tidyverse |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Shiny App                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │ mod_pattern │ │ mod_filters │ │  mod_graph  │ │mod_simulate │           │
│  │   _list     │ │             │ │             │ │             │           │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘ └──────┬──────┘           │
│         │               │               │               │                   │
│         └───────────────┴───────────────┴───────────────┘                   │
│                                 │                                           │
│                         ┌──────┴──────┐                                    │
│                         │ utils_data  │                                    │
│                         └──────┬──────┘                                    │
├─────────────────────────────────┼───────────────────────────────────────────┤
│                         ┌──────┴──────┐                                    │
│                         │    Arrow    │                                    │
│                         │  open_data  │                                    │
│                         └──────┬──────┘                                    │
├─────────────────────────────────┼───────────────────────────────────────────┤
│                         ┌──────┴──────┐                                    │
│  data/                  │   Parquet   │                                    │
│  ├── patterns/          │   Files     │                                    │
│  ├── sessions/          │(partitioned)│                                    │
│  ├── documents/         └─────────────┘                                    │
│  └── relationships/                                                        │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Data format | Partitioned Parquet via Arrow | Lazy evaluation for ~800k sessions |
| UI framework | bslib (Bootstrap 5) | Modern, responsive, corporate theming |
| Graph library | visNetwork | Best R integration, clustering support |
| Module pattern | Separate UI/server files | Easier testing, clearer ownership |
| Deployment | Docker with rocker/shiny-verse | Reproducible, includes Tidyverse |

---

## Theme

| Property | Value |
|----------|-------|
| Primary | `#007AC3` |
| Secondary | `#85BC20` |
| Background | Light |
| Font | System default (Bootstrap 5) |

---

## Data Schema

### patterns/pattern_metadata.parquet
| Column | Type | Description |
|--------|------|-------------|
| pattern_id | string | Unique pattern identifier |
| pattern_name | string | Display name |
| document_count | int32 | Number of documents |
| session_count | int32 | Number of sessions |
| created_at | timestamp | Creation date |

### sessions/ (partitioned by segment/industry)
| Column | Type | Description |
|--------|------|-------------|
| session_id | string | Unique session identifier |
| pattern_id | string | Associated pattern |
| segment | string | Business segment (partition key) |
| industry | string | Industry (partition key) |
| start_date | date | Session date |

### documents/document_metadata.parquet
| Column | Type | Description |
|--------|------|-------------|
| document_id | string | Unique document identifier |
| document_name | string | Display name |
| document_type | string | Category/type |

### relationships/document_cooccurrence.parquet
| Column | Type | Description |
|--------|------|-------------|
| source_id | string | Source document |
| target_id | string | Target document |
| weight | float64 | Co-occurrence count/strength |
| pattern_id | string | Pattern context |

---

## Conventions

### File Structure
```
app/
├── app.R                    # Entry point
├── R/
│   ├── mod_pattern_list_ui.R
│   ├── mod_pattern_list_server.R
│   ├── mod_filters_ui.R
│   ├── mod_filters_server.R
│   ├── mod_graph_ui.R
│   ├── mod_graph_server.R
│   ├── mod_simulation_ui.R
│   ├── mod_simulation_server.R
│   └── utils_data.R
├── www/
│   └── styles.css
└── data/                    # Symlink or mount

docker/
├── Dockerfile
├── docker-compose.yml
└── shiny-server.conf
```

### Code Style
- Tidyverse style guide
- `snake_case` for names
- `<-` for assignment
- `::` for package functions in modules
- roxygen2 documentation

---

## Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Initial load | < 3s | Time to first pattern list |
| Filter response | < 500ms | Time after filter change |
| Graph render (500 nodes) | < 2s | Time to interactive |
| Memory usage | < 4GB | Peak during operation |
