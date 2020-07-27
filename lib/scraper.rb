require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    students = []
    html.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

 def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    attributes = {}
    
    container = doc.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
    container.each do |link|
      if link.include?("twitter")
        attributes[:twitter] = link
      elsif link.include?("linkedin")
        attributes[:linkedin] = link
      elsif link.include?("github")
        attributes[:github] = link
      elsif link.include?(".com")
        attributes[:blog] = link
      end
    end
    attributes[:profile_quote] = doc.css(".profile-quote").text
    attributes[:bio] = doc.css("div.description-holder p").text
    attributes
    

  end
end
