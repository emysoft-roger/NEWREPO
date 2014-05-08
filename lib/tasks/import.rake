# encoding: utf-8
namespace :import do
  desc "Import gdoc"
  task :csv => :environment do
    require "open-uri"
    # url = "https://spreadsheets.google.com/feeds/list/0AoQyor23LnnSdDNzMjRPVWxiZW1fbUR1QnQ2S3o4UWc/od6/public/values?alt=json"

    url = "https://spreadsheets.google.com/feeds/list/0AoQyor23LnnSdFhxLU95M2w5YmVjRVhMbFJIM0JBd1E/od6/public/values?alt=json"

    file_path = Rails.root.join("values.json")

    hash = JSON.parse(open(file_path).read)
    hash = JSON.parse(open(url).read)

    # [User, Expert, Experience, Cursu, ExpertSecteur, ExpertCompetence].each do |klass|
      # klass.where(["created_at > ?", 10.minutes.ago]).destroy_all
    # end

    # [User, Expert, Cursu, Entreprise, Experience, ExpertCompetence, ExpertSecteur, Mission, Responsability, Application, Invitation].each(&:delete_all)
    # [User, Expert, Cursu, Entreprise, Experience, ExpertCompetence, ExpertSecteur, Mission, Responsability, Application, Invitation].each(&:delete_all)

    entries = hash["feed"]["entry"]
    pass = SecureRandom.hex(24)

    total = entries.size
    nn = 0

    entries.each do |entry|
      nn += 1

      email = entry["gsx$mail"]["$t"]
      prenom = entry["gsx$prénom"]["$t"]
      nom = entry["gsx$nom"]["$t"]
      tel = entry["gsx$numérodetéléphone"]["$t"]
      jj = entry["gsx$jj"]["$t"]
      mm = entry["gsx$mm"]["$t"]
      aaaa = entry["gsx$aaaa"]["$t"]
      titreprofil = entry["gsx$titreprofil"]["$t"]
      descriptionprofil = entry["gsx$descriptionprofil"]["$t"]

      mm = 1 if mm.blank? or mm.to_i > 12
      jj = 1 if jj.blank? or jj.to_i > 31

      user = User.new({
        email: email,
        password: pass,
        password_confirmation: pass
      })

      user.skip_confirmation_notification!

      if not user.save
        # puts "user Not saved: #{user.attributes.to_hash}"
        # puts "user Not saved: #{user.errors.full_messages}"
        # puts "user exists or not saved"
        puts "(#{nn} / #{total}) NO: user exist --> #{email}"
        next
        # exit 0
      end

      expert = Expert.new
      expert.skip_email = true

      expert.user_id = user.id
      expert.first_name = prenom
      expert.last_name = nom
      expert.tel = tel

      begin
        date = Date.new(aaaa.to_i, mm.to_i, jj.to_i)
      rescue
        puts "#{aaaa}, #{mm}, #{jj}"
      end

      expert.birthdate = date
      expert.profile_title = titreprofil if not titreprofil.blank?
      expert.services = descriptionprofil if not descriptionprofil.blank?

      if not expert.save
        puts email
        puts "expert Not saved: #{expert.errors.full_messages}"
        exit 0
      end

      sa = entry["gsx$sa"]["$t"]
      saexp = entry["gsx$sa-exp"]["$t"]
      dc = entry["gsx$dc"]["$t"]
      dcexp = entry["gsx$dc-exp"]["$t"]

      _sa = sa.titleize.strip.gsub(" é", " É")
      _sa = "Services" if _sa == "Sevices"
      _dc = dc.titleize.strip.gsub(" é", " É")

      sa = Secteur.find_by(name: _sa)
      dc = Competence.find_by(name: _dc)

      if not sa
        puts "no sa"
        puts _sa
        exit
      end

      if not dc
        puts "no dc"
        puts _dc
        exit
      end

      expert.expert_secteurs.create(secteur_id: sa.id, exp_years: saexp.to_i)
      expert.expert_competences.create(competence_id: dc.id, exp_years: dcexp.to_i)

      # EXPERIENCE
      exp1_entreprise = entry["gsx$exp1-entreprise"]["$t"]
      exp1_poste = entry["gsx$exp1-poste"]["$t"]
      exp1_description = entry["gsx$exp1-description"]["$t"]

      exp2_entreprise = entry["gsx$exp2-entreprise"]["$t"]
      exp2_poste = entry["gsx$exp2poste"]["$t"]
      exp2_description = entry["gsx$exp2-description"]["$t"]

      exp3_entreprise = entry["gsx$exp3-entreprise"]["$t"]
      exp3_poste = entry["gsx$exp3-poste"]["$t"]
      exp3_description = entry["gsx$exp3-description"]["$t"]

      # LOOP FOR 3 EXPERIENCES
      [1, 2, 3].each do |n|

        entreprise = eval("exp#{n}_entreprise")
        poste = eval("exp#{n}_poste")
        description = eval("exp#{n}_description")

        if entreprise.present? and poste.present? and description.present?

          saved = expert.experiences.create({
            entreprise: entreprise,
            poste: poste,
            description: description,
            })

          if not saved
            puts "#{saved.errors.full_messages}"
            exit
          end
        end

      end

      diplome1 = entry["gsx$diplôme1"]["$t"]
      dipl1_ecole = entry["gsx$dipl1-ecole"]["$t"]
      dipl1_annee = entry["gsx$dipl1-année"]["$t"]

      diplome2 = entry["gsx$diplôme2"]["$t"]
      dipl2_ecole = entry["gsx$dipl2-ecole"]["$t"]
      dipl2_annee = entry["gsx$dipl2-année"]["$t"]

      diplome3 = entry["gsx$diplôme3"]["$t"]
      dipl3_ecole = entry["gsx$dipl3-ecole"]["$t"]
      dipl3_annee = entry["gsx$dipl3-année"]["$t"]


      # LOOP FOR 3 CURSUS --> LATER
      [1, 2, 3].each do |n|

        diplome = eval("diplome#{n}")
        ecole = eval("dipl#{n}_ecole")
        annee = eval("dipl#{n}_annee")

        # puts diplome
        # puts ecole
        # puts annee

        if diplome.present?

          saved = expert.cursus.create({
            diplome: diplome,
            university: ecole,
            years: annee
            })

          if not saved
            puts "#{saved.errors.full_messages}"
            exit
          end
        end

      end

      ar_organisme = entry["gsx$ar-organisme"]["$t"]
      ar_poste = entry["gsx$ar-poste"]["$t"]
      ar_description = entry["gsx$ar-description"]["$t"]

      if ar_organisme.present? and ar_poste.present? and ar_description.present?
        saved = expert.responsabilities.create({
          organisme: ar_organisme,
          poste: ar_poste,
          description: ar_description
          })

        if saved.errors.size > 0
          puts "#{saved.errors.full_messages}"
          exit
        end
      end

      puts "(#{nn} / #{total}) OK --> #{email} (ar: #{expert.responsabilities.size})"
    end
  end
end