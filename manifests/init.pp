/*
Through a single parameterized class (puppet_maint), you may turn on and configure maintenance of the following items:  

* Puppet Reports (on disk)
* Client FileBucket
* Master FileBucket
* Puppet Reports (console db)
* Optimizing the console db

### Parameters
  $tidy_reports -- Whether to remove old reports 

 * Accepts boolean true or false (defaults to false)  

  $tidy_master_filebucket -- Whether to remove old content from the master filebucket

 * Accepts boolean true or false (defaults to false)

  $tidy_client_filebucket -- Whether to remove old content form the client filebucket  

* Accepts boolean true or false (defaults to false)

  $prune_report_db -- Whether to remove old reports from the Console db

* Accepts boolean true or false (defaults to false)

  $optimize_report_db -- Whether to optimize the reports db once a month

* Accepts boolean true or false (defaults to false)

  $max_report_age -- Maximum accepted report age

* Accepts a string based on the below criteria (defaults to '4w')

  $max_filebucket_age -- Maximum accepted age for bucket content 

* Accepts a string based on the below criteria (defaults to '4w')

Criteria for age variable values (from Tidy):
- **age**
    Tidy files whose age is equal to or greater than
    the specified time.  You can choose seconds, minutes,
    hours, days, or weeks by specifying the first letter of any
    of those words (e.g., '1w').

  $max_report_db_age_in_weeks -- Maximum accepted age for reports in the db

* Accepts a string representing number of weeks (defaults to '4')

*/
class puppet_maint (
  $tidy_reports = false,
  $tidy_master_filebucket = false,
  $tidy_client_filebucket = false,
  $prune_report_db = false,
  $optimize_report_db = false,
  $max_report_age = '4w',
  $max_filebucket_age = '4w',
  $max_report_db_age_in_weeks = '4',
) {

  # Make sure the class received boolean values to these variables
  validate_bool($tidy_reports, $tidy_master_filebucket, $tidy_client_filebucket)

  # Don't send tidy'd files to the filebucket
  Tidy { backup => false, }

  if $puppet_maint::tidy_reports {

    tidy { 'tidy_puppet_reports':
      path    => "${puppet_vardir}/reports",
      age     => $max_report_age,
      recurse => true,
      rmdirs  => true,
      matches => '*.yaml',
    }

  }

  if $puppet_maint::tidy_master_filebucket {

    tidy { 'tidy_master_filebucket':
      path    => "${puppet_vardir}/bucket",
      age     => $puppet_maint::max_report_age,
      recurse => true,
      rmdirs  => true,
    }

  }

  if $puppet_maint::tidy_client_filebucket {

    tidy { 'tidy_client_filebucket':
      path    => "${puppet_vardir}/clientbucket",
      age     => $puppet_maint::max_report_age,
      recurse => true,
      rmdirs  => true,
    }

  }

  if $puppet_maint::prune_report_db {
    cron { 'prune':
      command => "/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production reports:prune upto=${max_report_db_age_in_weeks} unit=wk",
      user    => 'root',
      hour    => '3',
      minute  => '5',
    }
  }

  if $puppet_maint::optimize_report_db {
    cron { 'optimize':
      command  => '/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production db:raw:optimize',
      user     => 'root',
      monthday => '1',
    }
  }

}
