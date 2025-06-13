# Open-Research Nexus

The Open-Research Nexus is an open-source initiative aiming to build a collaborative platform for researchers. It facilitates the discovery, analysis, and discussion of research papers and datasets, leveraging modern technologies for efficient data processing and retrieval.

## Monorepo Structure

This project is organized as a monorepo using Turborepo to manage dependencies and scripts across multiple applications and packages. The key directories at the root are:

* **`apps/`**: Contains independent applications and services. Each directory within `apps/` represents a distinct deployable unit.
  * `apps/web`: The main user-facing web application (e.g., built with React/Vue).
  * `apps/ingestion`: A backend service responsible for processing and indexing research data (e.g., built with Rust).
* **`packages/`**: Contains reusable libraries and code shared between applications and services.
  * `packages/db`: Database schema definitions, migrations, and client code (e.g., for Supabase).
  * `packages/ui`: Shared UI components (e.g., a component library).
  * `packages/utils`: Common utility functions and helper libraries.
* **`infrastructure/`**: Contains all Infrastructure as Code (IaC) definitions, managed by Terraform.
  * `infrastructure/terraform`: Root Terraform configuration and modules for cloud resource provisioning.

## Technology Stack

The project utilizes a diverse technology stack to cover frontend, backend, data storage, search, vector indexing, and infrastructure management:

* **Frontend:** React or Vue (specific choice TBD)
* **Backend Services:** Rust (for performance-critical tasks like ingestion)
* **Database & Auth:** Supabase (PostgreSQL, Authentication, Storage)
* **Vector Database:** Qdrant
* **Search Engine:** Typesense
* **Infrastructure as Code:** Terraform
* **Monorepo Management:** Turborepo
* **Deployment:** Vercel (for web app), Fly.io (for services)

## Infrastructure

All cloud infrastructure resources are defined and managed using Terraform. The configuration is located in the `infrastructure/terraform` directory. Dedicated modules are used for provisioning core services:

* `infrastructure/modules/supabase/`: Manages the Supabase project, including database, authentication settings, and storage buckets.
* `infrastructure/modules/qdrant/`: Manages the Qdrant Cloud cluster and initial collection setup.
* `infrastructure/modules/typesense/`: Manages the Typesense Cloud cluster.

## Database

The primary database is managed by Supabase, providing a PostgreSQL database instance. The database schema and migration scripts are located in `packages/db/migrations/`.

The initial schema is defined in `packages/db/migrations/001_initial_schema.sql`. This script includes:

* Enabling the `pgvector` extension for vector embeddings.
* Creating core tables like `users`, `papers`, `datasets`, `research_questions`, and `paper_chunks`.
* Adding a `VECTOR(768)` column and an `ivfflat` index for embeddings in the `paper_chunks` table.

## Getting Started

To set up the project locally for development:

1. **Prerequisites:** Ensure you have the following installed:
   * Node.js (v18 or later recommended)
   * pnpm (recommended package manager for monorepos, install with `npm install -g pnpm`) or yarn/npm
   * Docker (for running local dependencies like database or services if needed)
   * Git
2. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd open-research-nexus
   ```
3. **Install dependencies:**
   ```bash
   pnpm install
   ```
   or
   ```bash
   yarn install
   ```
   or
   ```bash
   npm install
   ```

## Environment Variables

The project requires environment variables for connecting to external services (Supabase, Qdrant, Typesense). Create a `.env` file at the root of the monorepo based on the `.env.example` template.

```dotenv
.env.example
Supabase Configuration
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY= # Required for services with elevated privileges

Qdrant Cloud Configuration
QDRANT_CLUSTER_URL=
QDRANT_API_KEY=

Typesense Cloud Configuration
TYPESENSE_CLUSTER_HOST=
TYPESENSE_API_KEY=

Add other environment variables as needed for specific apps or packages
```

Populate these variables with your actual credentials and endpoint URLs obtained from your deployed infrastructure or local development services.

## Development Commands

Turborepo orchestrates various tasks across the monorepo. The primary commands are run using `pnpm` (or your chosen package manager):

* `pnpm dev`: Starts the development servers/watchers for all configured projects (`apps/web`, `apps/ingestion`, etc.). Runs with caching disabled (`"cache": false`).
* `pnpm build`: Builds all applications and packages configured in the `build` pipeline. Outputs are cached.
* `pnpm test`: Runs tests for all projects configured in the `test` pipeline.
* `pnpm lint`: Runs linters across all projects configured in the `lint` pipeline.

You can run commands for specific applications or packages using the `--filter` flag, e.g.:

```bash
pnpm --filter web dev
pnpm --filter ingestion build
pnpm --filter db test
```

## Deployment

Deployment of the Open-Research Nexus components is automated via GitHub Actions pipelines.

* The `apps/web` application is deployed to Vercel.
* The `apps/ingestion` service is deployed to Fly.io.
* Infrastructure changes managed by Terraform (`infrastructure/terraform`) are typically applied via a separate CI/CD workflow, often requiring manual approval for production environments.
