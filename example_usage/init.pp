class { 'puppet_maint':
  tidy_reports => true,
  tidy_master_filebucket => true,
  prune_report_db => true,
  optimize_report_db => true,
  max_report_age => '4w',
  max_filebucket_age => '2w',
  max_report_db_age_in_weeks => '4',
}
