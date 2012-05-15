class { 'puppet_maint':
  tidy_reports => true,
  tidy_master_filebucket => true,
  max_report_age => '4w',
  max_filebucket_age => '2w',
}
