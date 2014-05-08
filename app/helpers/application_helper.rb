# encoding: utf-8
module ApplicationHelper
  def assets_path(asset_name)
    if Rails.env.production?
      $json ||= File.open(Rails.root.join('assets.json')).read
      $mapping ||= JSON.parse($json)
      "/assets/build/#{$mapping[asset_name]}"
    else
      "/assets/build/#{asset_name}"
    end
  end

  def expert_image_tag(expert)
    if expert.image_id
      cl_image_tag(expert.image_id, crop: :fill, width: 140, height: 140)
    else
      image_tag("/static/images/show-avatar.png", size: "140x140")
    end
  end

  def list_budget
    list = [
      ["Moins de 2.000 €", "0-2000"],
      ["2.000 € - 5.000 €", "2000-5000"],
      ["5.000 € - 10.000 €", "5000-10000"],
      ["10.000 € - 50.000 €", "10000-50000"],
      ["Plus de 50.000 €", "50000-500000"]
    ]

    list
  end

  def mapping_budget(mission, i = 0)
    case
    when mission.budget_min == 0
      return list_budget[0][i]
    when mission.budget_max == 500_000
      return list_budget.last[i]
    when mission.budget_max == 50_000
      return list_budget[3][i]
    when mission.budget_max == 10_000
      return list_budget[2][i]
    when mission.budget_max == 5_000
      return list_budget[1][i]
    end
  end

  def list_duree
    list = [
      ["Moins d'un mois", "0-4"],
      ["1 mois à 3 mois", "4-12"],
      ["3 mois à 6 mois", "12-24"],
      ["6 mois à 1 an", "24-52"],
      ["Plus de 1 an", "52-520"]
    ]

    list
  end

  def mapping_duree(mission, i = 0)
    case
    when mission.duration_min == 0
      return list_duree[0][i]
    when mission.duration_max == 520
      return list_duree.last[i]

    when mission.duration_max == 52
      return list_duree[3][i]
    when mission.duration_max == 24
      return list_duree[2][i]
    when mission.duration_max == 12
      return list_duree[1][i]
    end
  end
end
