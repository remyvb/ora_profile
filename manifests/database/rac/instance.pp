# ora_profile::database::rac::instance
#
# Add Undo tablespace, Thread and init parameters for RAC instances
#
# @summary A short summary of the purpose of this class
#
# @example
#   ora_profile::database::rac::instance{'instance_name'}
define ora_profile::database::rac::instance(
  String[1]        $on,
  Integer          $number,
  Integer          $thread,
  String[1]        $datafile,
  Easy_type::Size  $undo_initial_size,
  Easy_type::Size  $undo_next,
  Enum['on','off'] $undo_autoextend,
  Easy_type::Size  $undo_max_size,
  Easy_type::Size  $log_size,
){

  $download_dir = lookup('ora_profile::database::download_dir')

  ora_tablespace {"UNDOTBS${number}@${on}":
    contents   => 'undo',
    datafile   => [$datafile],
    size       => $undo_initial_size,
    autoextend => $undo_autoextend,
    next       => $undo_next,
    max_size   => $undo_max_size,
  }

  ora_init_param {"SPFILE/instance_number:${name}@${on}":
    ensure => present,
    value  => $number,
  }

  ora_init_param {"SPFILE/instance_name:${name}@${on}":
    ensure => present,
    value  => $name,
  }

  ora_init_param {"SPFILE/thread:${name}@${on}":
    ensure => present,
    value  => $thread,
  }

  ora_init_param {"SPFILE/undo_tablespace:${name}@${on}":
    ensure  => present,
    value   => "UNDOTBS${number}",
    require => Ora_tablespace["UNDOTBS${number}@${on}"],
  }

  if ( $thread != 1 ) {
    file{ "${download_dir}/add_logfiles_${thread}.sql":
      ensure  => present,
      owner   => $ora_profile::database::os_user,
      group   => $ora_profile::database::install_group,
      content => template('ora_profile/add_logfiles.sql.erb')
    }

    -> ora_exec {"@${download_dir}/add_logfiles_${thread}.sql@${on}":
      unless  => "select count(9) from gv\$log where thread# = ${thread} having count(9) >= 3",
      require => File["${download_dir}/add_logfiles_${thread}.sql"],
      before  => Ora_thread["${thread}@${on}"],
    }
  }

  ora_thread {"${thread}@${on}":
    ensure  => 'enabled',
    require => [
      Ora_init_param["SPFILE/undo_tablespace:${name}@${on}"],
    ],
  }

}
