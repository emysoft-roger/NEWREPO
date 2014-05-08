# encoding: utf-8
require 'populator'
require 'ffaker'

namespace :db do
  desc "Bootstrap Data"
  task :bootstrap => :environment do

    str = 'Achat
    Administratif
    Commercial, Vente
    Communication, Documentation
    Direction Générale
    Sécurité, Entretien, Maintenance
    Finance, Comptabilité, Économie
    Informatique
    Juridique, Fiscalité
    Logistique
    Marketing
    Ingénieur, Production
    Qualité, Service, Environnement
    Recherche, Étude, Laboratoire
    Relation clients, SAV
    Service généraux
    Ressources humaines'

    count = 1
    str.split("\n").each do |name|
      Competence.create(name: name.strip.titleize, id: count)
      count = count + 1
    end

    str = 'Banque, Assurance, Finance
    Construction BTP
    Distribution
    Industries
    Immobilier
    Informatique, Télecom, Internet
    Services
    Services publics, Administration'

    count = 1
    str.split("\n").each do |name|
      Secteur.create(name: name.strip.titleize, id: count)
      count = count + 1
    end

    str = "Conseil
    Formation, Coaching
    Vente, Commercial, Apport d'affaires
    Management de transition
    Autres prestations"

    count = 1
    str.split("\n").each do |name|
      Category.create(name: name.strip.titleize, id: count)
      count = count + 1
    end
  end

  desc "Erase and fill database"
  task :populate => :environment do

    [Secteur, Competence, User, Expert, AdminUser, Category, Cursu, Entreprise, Experience, ExpertCompetence, ExpertSecteur, Mission,
      Responsability, Application].each(&:delete_all)

    # [Secteur, Competence, User, Expert, Cursu, Entreprise, Experience, ExpertCompetence, ExpertSecteur, Mission, Responsability, Application, Invitation].each(&:delete_all)

    Rake::Task["db:bootstrap"].invoke

    N = 30

    AdminUser.create do |a|
      a.email = 'admin@local.dev'
      a.password = a.password_confirmation = 'admin@local.dev'
    end

    mail_pass = Faker::Internet.email

    u = User.new do |_user|
      _user.email = mail_pass
      _user.approved = [true, false].sample
      _user.password = _user.password_confirmation = mail_pass
    end

    budget_list = [
      "0-2000",
      "2000-5000",
      "5000-10000",
      "10000-50000",
      "50000-500000"
    ]

    duree_list = [
      "0-4",
      "4-12",
      "12-24",
      "24-52",
      "52-520"
    ]

    u.delete


    N.times do |i|

      mail_pass = Faker::Internet.email
      u = User.new do |user|
        user.email = mail_pass
        user.approved = [true, false].sample
        user.password = mail_pass
        user.password_confirmation = mail_pass
        user.sign_in_count = 0
      end

      u.skip_confirmation!
      u.save

      # Create expert
      e = Expert.new do |expert|
        expert.user_id = u.id
        expert.first_name = Faker::Name.first_name
        expert.last_name = Faker::Name.last_name
        expert.tel = "06789876587"
        expert.birthdate = 30.years.ago
        expert.profile_title = Faker::Lorem.words(2).join(" ")
        expert.services = Faker::Lorem.words(10).join(" ")
      end

      e.skip_email!
      e.save

      rand(1..3).times do |_|
        e.expert_secteurs.build({
          secteur_id: Secteur.order("RANDOM()").first.id,
          exp_years: rand(1..19),
        })
      end

      rand(1..3).times do |_|
        e.expert_competences.build({
          competence_id: Competence.order("RANDOM()").first.id,
          exp_years: rand(1..19),
        })
      end

      rand(1..2).times do |_|
        e.experiences.build({
          description: Faker::Lorem.words(2).join(" "),
          entreprise: Faker::Lorem.words.join(" "),
          poste: Faker::Lorem.words(2).join(" "),
        })
      end

      rand(0..2).times do |_|
        e.responsabilities.build({
          description: Faker::Lorem.words.join(" "),
          organisme: Faker::Lorem.words(2).join(" "),
          poste: Faker::Lorem.words(2).join(" "),
        })
      end

      rand(1..2).times do |_|
        e.cursus.build({
          diplome: Faker::Lorem.words(2).join(" (diplome) "),
          university: Faker::Lorem.words(2).join(" "),
          years: rand(1970..1999),
        })
      end

      e.save
    end

    N.times do |i|

      mail_pass = Faker::Internet.email

      u = User.new do |user|
        user.email = mail_pass
        user.approved = true
        user.password = mail_pass
        user.password_confirmation = mail_pass
        user.sign_in_count = 0
      end

      u.skip_confirmation!
      u.save

      # Create entreprise
      e = Entreprise.new do |entreprise|
        entreprise.user_id = u.id

        entreprise.name = Faker::Name.first_name
        entreprise.tel = "067898654"
      end

      e.skip_email!
      e.save

      # missions per enterprise
      rand(3..10).times do |_|

        m = Mission.new do |mission|
          mission.name = Faker::Lorem.words(6).join(" ")
          mission.entreprise_id = e.id

          budget = budget_list.sample.split("-")
          duration = duree_list.sample.split("-")

          mission.budget_min = budget[0].to_i
          mission.budget_max = budget[1].to_i

          mission.duration_min = duration[0].to_i
          mission.duration_max = duration[1].to_i

          mission.town = ["Paris", "Bordeaux", "Lille"].sample
          mission.description = Faker::Lorem.words(100).join(" ")

          mission.category_id = Category.order("RANDOM()").first.id
          mission.secteur_id = Secteur.order("RANDOM()").first.id
          mission.competence_id = Competence.order("RANDOM()").first.id

          mission.validated = [true, false].sample
          mission.validated_at = ([true, false].sample) ? Time.now : nil
        end

        m.skip_email!
        m.save
      end

      # new
      rand(2..8).times do
        m = e.missions.order("RANDOM()").first
        expert = Expert.order("RANDOM()").first
        m.expert_id = expert.id
        m.save
      end

      # doing
      rand(1..6).times do
        m = e.missions.order("RANDOM()").first
        expert = Expert.order("RANDOM()").first
        m.expert_id = expert.id
        m.state = 1
        m.save
      end

      # done
      rand(2..10).times do
        m = e.missions.order("RANDOM()").first
        expert = Expert.order("RANDOM()").first
        m.expert_id = expert.id
        m.state = 2
        m.save
      end

      # pending
      rand(2..6).times do
        m = e.missions.order("RANDOM()").first
        expert = Expert.order("RANDOM()").first
        m.expert_id = expert.id
        m.state = 3
        m.save
      end

      # applications new

      [0, 1, 2, 3].each do |state|

        rand(0..8).times do |_|
          m = e.missions.order("RANDOM()").first
          expert = Expert.order("RANDOM()").first
          ap = m.applications.new({
            expert_id: expert.id,
            state: state,
            motivation: Faker::Lorem.words(50).join(" "),
            price: rand(10..9999999),
          })
          ap.skip_email = true
          ap.save
        end

      end


      # invitation new
      [0, 1, 2].each do |state|

        rand(1..8).times do |_|
          m = e.missions.pending.order("RANDOM()").first

          if m
            expert = Expert.order("RANDOM()").first

            ap = m.invitations.new({
              expert_id: expert.id,
              state: state,
            })
            ap.skip_email = true
            ap.save

          end
        end

      end

      # Notes
      rand(1..8).times do |_|
        m = e.missions.done.order("RANDOM()").first

        if m
          expert = Expert.order("RANDOM()").first

          ap = m.notes.new({
            expert_id: expert.id,
            ponctualite: rand(0..5),
            qualite: rand(0..5),
            disponibilite: rand(0..5),
            courtoisie: rand(0..5),
            description: [Faker::Lorem.words(10).join(" "), false].sample
          })

          ap.save
        end
      end

    end
  end
end
