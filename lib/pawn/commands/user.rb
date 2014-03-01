desc 'manage users'
long_desc 'This command is used to create and manage application users.'

command :user do |user|

  user.desc 'create a new user'
  user.long_desc <<________
Add a new user by specifying it's USER_EMAIL defined as: \n
USER_EMAIL - the email address that serves as the identity for this user
________

  user.arg_name 'USER_EMAIL'
  user.command :create do |create|
    user.desc 'make user admin'
    user.switch :admin
    create.action do | global_options, options, args |
      arguments_error_message = 'you must specify an email address to identify the user to be created'
      raise arguments_error_message if args.length < 1
      email_address = args[0].downcase
      user = User.find_by_email(email_address)
      admin = options[:admin]
      if user.nil?
        password = read_password
        user = User.create!(:email=>email_address, :password=>password, :admin=>admin)
        puts "User #{new_user.email} created" if new_user
      elsif admin
        user.admin = admin
        user.save!
      else
        raise "A user with email #{email_address} already exists."
      end
      puts "User #{user.email} is now an admin." if admin
    end
  end

  user.desc 'reset user password'
  user.long_desc <<________
Force a new password onto an existing user
________

  user.arg_name 'USER_EMAIL'
  user.command :password do |pwcmd|
    pwcmd.action do | global_options, options, args |
      arguments_error_message = 'you must specify an email address to identify the user for password reset'
      raise arguments_error_message if args.length < 1
      email_address = args[0].downcase
      user = User.find_by_email(email_address)
      raise "No user with email #{email_address} already exists." unless user
      user.password = read_password
      user.save!
      puts "Password updated for #{user.email}"
    end
  end

end

def read_password
  # read the password silently off stdin
  stty_settings = %x[stty -g]
  print 'Password: '
  begin
    %x[stty -echo]
    password = $stdin.gets.chomp
  ensure
    %x[stty #{stty_settings}]
  end
  raise 'password must be at least 8 characters' if password.length < 8
  password
end



