# OCI Terraform Multi-region

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)
](https://github.com/daniel-armbrust/oci-terraform-multiregion/archive/refs/heads/main.zip)

## Description

This is an example to use _[Terraform](https://www.terraform.io/)_ to provision multi-region cloud resources on _[OCI](https://www.oracle.com/cloud/)_.
Feel free to contribute and keep it better.

## Description of source code
```
.
├── README.md                   
├── LICENSE
├── datasources.tf              # Terraform global data sources
├── drg.tf                      # Dynamic Routing Gateways (DRG)
├── gru_compute.tf              # Compute definitions for "Brazil East (Sao Paulo) - GRU"
├── gru_vcn-dev.tf              # VCN DEVELOPMENT definitions for "Brazil East (Sao Paulo) - GRU"
├── gru_vcn-hml.tf              # VCN HOMOLOGATION definitions for "Brazil East (Sao Paulo) - GRU"
├── gru_vcn-prd.tf              # VCN PRODUCTION definitions for "Brazil East (Sao Paulo) - GRU"
├── gru_vcn-shared.tf           # VCN SHARED definitions for "Brazil East (Sao Paulo) - GRU"
├── locals.tf                   # Terraform global locals definitions
├── modules/                    # Terraform modules definitions for this project
├── providers.tf                # List of Terraform providers with region alias used in this project
├── terraform.tfvars.example    # Environment specific variables (example)
├── vars.tf                     # Terraform main input variables
├── vcp_compute.tf              # Compute definitions for "Brazil Southeast (Vinhedo) - VCP"
└── vcp_vcn-dr.tf               # VCN DR definitions for "Brazil Southeast (Vinhedo) - VCP"

```

## How to use

1. Create your _[OCI Always Free Account](https://www.oracle.com/cloud/free/)_.
2. Create an _[OCI User](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingusers.htm)_ with right policies to manage the cloud resources.
3. Subscribe your tenancy to a _[new region](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingregions.htm)_.
4. Generate and upload an _[API Signing Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm)_ for your user.
5. Download and install _[Terraform](https://www.terraform.io/downloads.html)_.
6. _[Clone](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository-from-github/cloning-a-repository)_ this repository.
7. Create a new _"terraform.tfvars"_ file with identity and access parameters from your _OCI_ user and account.
8. Run _terraform init_, _plan_, _apply_ and go fun.

NOTE: This project use an Terraform experimental feature. Don't be in panic if you encounter some "warnings" in output from terraform commands. I hope this experimental feature will disapear in future terraform releases.

## Topology
```
+================================================================================+
|                                                   REGION - GRU (sa-saopaulo-1) |
|                                                                                |
|   +------------------------------------------+                                 |
|   | VCN SHARED                               |                                 |
|   | gru_vcn-shared - 10.6.0.0/24             |                                 |
|   |                                          |                                 |
|   |  +------------------------------------+  |                                 |
|   |  | gru_rtb_subpub-frontend_vcn-shared |  |                                 |
|   |  |                        10.6.0.0/26 |  |                                 |
|   |  +------------------------------------+  |                                 |
|   +-------+----------------------------------+                                 |
|           |                                                                    |
|           |                    +------------------------------------------+    |
|           |                    | VCN PRODUCTION                           |    |
|           |                    | gru_vcn-prd - 10.0.0.0/16                |    |
|           |                    |                                          |    |  
|           |                    |  +------------------------------------+  |    |
|           |                    |  | gru_subpub-frontend_vcn-prd        |  |    |  
|           |                    |  |                        10.0.1.0/24 |  |    |
|           |    +---------------+  +------------------------------------+  |    |
|           |    |               |  +------------------------------------+  |    |
|           |    |               |  | gru_subprv-backend_vcn-prd         |  |    |
|           |    |               |  |                        10.0.2.0/24 |  |    |
|           |    |               |  +------------------------------------+  |    |
|           |    |               |  +------------------------------------+  |    |
|           |    |               |  | gru_subprv-database_vcn-prd        |  |    |
|           |    |               |  |                        10.0.4.0/24 |  |    |
|           |    |               |  +------------------------------------+  |    |
|           |    |               +------------------------------------------+    |
|           |    |                                                               |
|           |    |               +------------------------------------------+    |
|           |    |               | VCN HOMOLOGATION                         |    |
|           |    |               | gru_vcn-hml - 10.2.0.0/16                |    |
|           |    |               |                                          |    |
|           |    |               |  +------------------------------------+  |    |
|           |    |               |  | gru_subpub-frontend_vcn-hml        |  |    |
|       +---+----+------+        |  |                        10.2.1.0/24 |  |    |
|       | DRG - gru_drg |        |  +------------------------------------+  |    |
|       +-+-----+---+---+        |  | gru_subprv-backend_vcn-hml         |  |    |
|         |     |   |            |  |                        10.2.2.0/24 |  |    |
|         |     |   |            |  +------------------------------------+  |    |
|         |     |   +------------+  +------------------------------------+  |    |
|         |     |                |  | gru_subprv-database_vcn-hml        |  |    | 
|         |     |                |  |                        10.2.4.0/24 |  |    |
|         |     |                |  +------------------------------------+  |    |
|         |     |                +------------------------------------------+    |
|         |     |                                                                |
|         |     |                +------------------------------------------+    |
|         |     |                | VCN DEVELOPMENT                          |    |
|         |     |                | gru_vcn-dev - 10.4.0.0/16                |    |
|         |     +----------------+                                          |    |
|         |                      |  +------------------------------------+  |    |
|         |                      |  | gru_subprv-backend_vcn-dev         |  |    |
|         |                      |  |                        10.4.2.0/24 |  |    |
|         |                      |  +------------------------------------+  |    |
|         |                      |  +------------------------------------+  |    |
|         |                      |  | gru_subprv-database_vcn-dev        |  |    |
|         |                      |  |                        10.4.4.0/24 |  |    |
|         |                      |  +------------------------------------+  |    | 
|         |                      +------------------------------------------+    |
|         |                                                                      | 
+=========|======================================================================+
          | 
          |
+=========|======================================================================+
|         |                                          REGION - VCP (sa-vinhedo-1) |
|         |                                                                      |
|   +-----+---------+                                                            |
|   | DRG - vcp_drg |                                                            |
|   +----------+----+                                                            |
|              |                                                                 |
|              |                  +------------------------------------------+   |
|              |                  | VCN DR                                   |   |
|              |                  | vcp_vcn-dr - 172.16.0.0/16               |   |
|              +------------------+                                          |   |
|                                 |  +------------------------------------+  |   |
|                                 |  | vcp_subprv-database_vcn-dr         |  |   |
|                                 |  |                     172.16.10.0/24 |  |   |
|                                 |  +------------------------------------+  |   |
|                                 +------------------------------------------+   |
|                                                                                |
+================================================================================+
```