namespace :import_keys do
  task gsuite: :environment do

    puts("--- BEGINNING import")

    import_path = "lib/import/gsuite"
    key_paths = Dir.entries(import_path)
                  .select{ |file| file != "." && file != ".." }
                  .map{ |file| "#{import_path}/#{file}" }
    puts("... found no keys") if key_paths.empty?

    key_paths.each do |key_path|
      puts("... importing #{key_path}")

      imported_path = Network.import_gsuite_key key_path
      FileUtils.rm(key_path)
      %x(#{"./bin/blackbox_register_new_file '#{imported_path}'"})

      puts("... imported and deleted #{key_path}")
      puts("... gitignored #{imported_path}")
      puts("... placed #{imported_path}.gpg under version control")
      puts("... automatically generated commit recording above actions")
      puts("... (you may wish to amend the last commit)")
    end

    puts("+++ DONE with import")
  end
end
