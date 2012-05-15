/*
Through a single parameterized class (puppet_maint), you may turn on and configure maintenance of the following items:  

* Puppet Reports
* Client FileBucket
* Master FileBucket

### Parameters
  $tidy_reports -- Whether to remove old reports 

 * Accepts boolean true or false (defaults to false)  

  $tidy_master_filebucket -- Whether to remove old content from the master filebucket

 * Accepts boolean true or false (defaults to false)

  $tidy_client_filebucket -- Whether to remove old content form the client filebucket  

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
*/
class puppet_maint (
  $tidy_reports = false,
  $tidy_master_filebucket = false,
  $tidy_client_filebucket = false,
  $max_report_age = '4w',
  $max_filebucket_age = '4w',
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

}
