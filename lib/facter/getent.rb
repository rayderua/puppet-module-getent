# vim: set ts=2 sw=2 et :
# encoding: utf-8

# vim: set ts=2 sw=2 et :
# encoding: utf-8

Facter.add('getent') do
    setcode do
        getent = Hash.new

        if Facter::Core::Execution.which('getent')
            ENV['LC_ALL'] = 'C'

            databases = {
                "passwd" => { 'index' => 0, 'mapping' => [ 'username', 'password', 'uid', 'gid', 'comment', 'home', 'shell' ] },
                "shadow" => { 'index' => 0, 'mapping' => [ 'username', 'password', 'change', 'minimum', 'maximum', 'inactive', 'expire' ] },
                "group"  => { 'index' => 0, 'mapping' => [ 'name', 'password', 'gid', 'members' ] },
                "gshadow" => { 'index' => 0, 'mapping' => [ 'name', 'password', 'administrators', 'users' ] },
                "aliases" => { 'index' => 0, 'mapping' => ['name', 'recipients']}
            }

            # Collect from databases
            databases.each do | db, db_conf |
                getent[db] = Hash.new

                Facter::Util::Resolution.exec('/usr/bin/getent ' + db.to_s).each_line do | line |
                    line.strip!
                    entity = line.split(':')

                    mapped = Hash.new
                    db_conf['mapping'].each_with_index do | name, index |
                        mapped[name] = entity[index]
                    end

                    # Aggregate entity
                    case db
                        when 'passwd'
                            mapped['uid'] = mapped['uid'].to_i
                            mapped['gid'] = mapped['gid'].to_i
                        when 'shadow'
                            mapped['change'] = mapped['change'].to_i
                            mapped['minimum'] = mapped['minimum'].to_i
                            mapped['maximum'] = mapped['maximum'].to_i
                            mapped['inactive'] = mapped['inactive'].to_i
                            mapped['expire'] = mapped['expire'].to_i
                        when 'group'
                            mapped['gid'] = mapped['gid'].to_i
                            mapped['members'] = mapped['members'] ? mapped['members'].split(',') : Array.new
                        when 'gshadow'
                            mapped['administrators'] = mapped['administrators'] ? mapped['administrators'].split(',') : Array.new
                            mapped['users'] = mapped['users'] ? mapped['users'].split(',') : Array.new
                        when 'aliases'
                            mapped['recipients'].strip!
                            mapped['recipients'] = mapped['recipients'] ? mapped['recipients'].split(',') : Array.new
                    end
                    getent[db][entity[db_conf['index']]] = mapped
                end
            end

            # Collect hosts
            getent['hosts'] = Hash.new
            Facter::Util::Resolution.exec('/usr/bin/getent hosts').each_line do | line |
                line.strip!
                hosts = line.split(' ')
                ip = hosts.shift().to_s

                if ! getent['hosts'].key?(ip)
                    getent['hosts'][ip] = Array.new
                end
                hosts.each do | host |
                    getent['hosts'][ip].push(host.to_s)
                end
                getent['hosts'][ip] = getent['hosts'][ip].uniq
            end
        end
        getent
    end
end
