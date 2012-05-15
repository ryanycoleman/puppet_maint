# Module: puppet_maint

Provides Tidy resources for cleaning up various Puppet directories.

## About

Through a single parameterized class (puppet_maint), you may turn on and configure maintenance of the following items:  

* Puppet Reports
* Client FileBucket
* Master FileBucket

### Parameters
  $tidy\_reports -- Whether to remove old reports 

 * Accepts boolean true or false (defaults to false)  

  $tidy\_master\_filebucket -- Whether to remove old content from the master filebucket

 * Accepts boolean true or false (defaults to false)
  
  $tidy\_client\_filebucket -- Whether to remove old content form the client filebucket  

* Accepts boolean true or false (defaults to false)

  $max\_report\_age -- Maximum accepted report age

* Accepts a string based on the below criteria (defaults to '4w')

  $max\_filebucket\_age -- Maximum accepted age for bucket content 

* Accepts a string based on the below criteria (defaults to '4w')

Criteria for age variable values (from Tidy):
<pre>
- **age**
    Tidy files whose age is equal to or greater than
    the specified time.  You can choose seconds, minutes,
    hours, days, or weeks by specifying the first letter of any
    of those words (e.g., '1w').
</pre>


## Example Usage

In the simplest use, you'd declare the class in site.pp for all of your agents.
<pre>
class { 'puppet\_maint':
  tidy\_reports => true,
  tidy_master_filebucket => true,
  max\_report\_age => '4w',
  max\_filebucket\_age => '2w',
}
</pre>

### Dependancies
This module requires puppetlabs-stdlib for the puppet_vardir fact which makes the resources work properly on both FOSS and PE Puppet deployments.

### Known Issues
* Filebucket Tidy's will tidy $vardir/bucket or $vardir/clientbucket if they're empty. Puppet recreates them next Puppet run.
* Unless this module uses the PE facts from facts.d, Tidy[tidy_master_filebucket] will attempt to run on client systems, resulting in "info: /Stage[main]/Puppet_maint/Tidy[tidy_master_filebucket]: File does not exist"
  * Same with Tidy[tidy_puppet_reports]
  * This does not cause failed runs, just a couple extra and useless resources on agent systems.

### Contributions Needed
* Resolved Known Issues
* Spec Tests
* Way of determining agent vs master roles without PE specific facts
* Extra stuff that you're thinking about
  * Keep in mind that the interface should be simple boolean triggers, defaulting to not purging files from a system.