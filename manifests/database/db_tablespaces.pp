#++--++
#
# ora_profile::db_tablespaces
#
# @summary This class contains the definition for all the tablespaces you'd like on your system.
# When these customizations aren't enough, you can replace the class with your own class. See [ora_profile::database](./database.html) for an explanation on how to do this.
#
# @param [Hash] list
#    A list of database tablespaces to define.
#    The default value is: `{}`
#    This is a simple way to get started. It is easy to get started, but soon your hiera yaml become a nigtmare. Our advise is when you need to let puppet manage your Oracle profiles, to override this class and  add your own puppet implementation. This is much better maintainable
#    and adds more consistency.
#
#--++--
class ora_profile::database::db_tablespaces(
  Hash  $list,
) inherits ora_profile::database {

  if $list.keys.size > 0 {
    echo {"Ensure DB tablespace(s) ${list.keys.join(',')}":
      withpath => false,
    }
  }
  #
  # This is a simple way to get started. It is easy to get started, but
  # soon your hiera yaml become a nigtmare. Our advise is when you need
  # to let puppet manage your tablespaces, to override this class and 
  # add your own puppet implementation. This is much better maintainable
  # and adds more consistency,
  #
  create_resources(ora_tablespace, $list)
}
