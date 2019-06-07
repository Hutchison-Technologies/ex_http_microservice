use Mix.Config

config :junit_formatter,
  report_file: "junit.xml",
  report_dir: ".",
  print_report_file: true,
  prepend_project_name?: false
