locals {
  cis_v200_common_tags = merge(local.gcp_compliance_common_tags, {
    benchmark   = "cis_gke_130"
    cis_version = "v1.3.0"
  })
}

benchmark "cis_v130" {
  title         = "CIS v1.3.0"
  description   = "The CIS GKE Google Cloud Platform Foundations Security Benchmark covers foundational elements of GKE Google Cloud Platform."
  documentation = file("./cis_gke_v130/docs/cis_overview.md")
  children = [
    benchmark.cis_v200_1,
    benchmark.cis_v200_2,
    benchmark.cis_v200_3,
    benchmark.cis_v200_4,
    benchmark.cis_v200_5,
    benchmark.cis_v200_6,
    benchmark.cis_v200_7
  ]

  tags = merge(local.cis_gke_v130_common_tags, {
    type = "Benchmark"
  })
}
