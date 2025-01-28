resource "aws_redshiftserverless_workgroup" "tft_redshift_workgroup" {
  namespace_name = "tft-redshift"
  workgroup_name = "tft-redshift-workgroup"
}

resource "aws_redshiftserverless_namespace" "tft_redshift_namespace" {
  namespace_name = "tft-redshift"
}
