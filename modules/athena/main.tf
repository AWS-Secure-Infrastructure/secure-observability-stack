resource "aws_athena_workgroup" "this" {
  name = "${var.name}-workgroup"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${var.athena_results_bucket}/"
    }
  }

  tags = var.tags
}

resource "aws_glue_catalog_database" "this" {
  name = "${var.name}_cloudtrail_logs"

  tags = var.tags
}

resource "aws_glue_catalog_table" "cloudtrail" {
  name          = "cloudtrail_logs"
  database_name = aws_glue_catalog_database.this.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification = "json"
  }

  storage_descriptor {
    location      = "s3://${var.s3_bucket_name}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"

    serde_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns {
      name = "eventVersion"
      type = "string"
    }

    columns {
      name = "eventTime"
      type = "string"
    }

    columns {
      name = "eventName"
      type = "string"
    }

    columns {
      name = "userIdentity"
      type = "string"
    }
  }
}
