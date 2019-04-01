require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    c = 0
    doc.css(".student-card").each do |student|
      students[c] = {name: student.css("h4.student-name").text,
      location: student.css("p.student-location").text,
      profile_url: student.css("a").attribute("href").value}
      c += 1
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    prof = Nokogiri::HTML(open(profile_url))
    stud_prof = {}
    prof.css("div.vitals-text-container").each do |student|
      social_media = prof.css("div.social-icon-container").css("a")
      social_media.each do |social_icon|
        if social_icon.css("img").attribute("src").value.match(/\S+twitter-icon.png/)
          stud_prof[:twitter] = social_icon.attribute("href").value
        elsif social_icon.css("img").attribute("src").value.match(/\S+linkedin-icon.png/)
          stud_prof[:linkedin] = social_icon.attribute("href").value
        elsif social_icon.css("img").attribute("src").value.match(/\S+github-icon.png/)
          stud_prof[:github] = social_icon.attribute("href").value
        elsif social_icon.css("img").attribute("src").value.match(/\S+rss-icon.png/)
          stud_prof[:blog] = social_icon.attribute("href").value
        end
      end
      stud_prof[:profile_quote] = prof.css("div.vitals-text-container").css("div.profile-quote").text
      stud_prof[:bio] = prof.css(".description-holder").css("p").text
    end
    stud_prof
  end

end
