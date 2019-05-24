require 'open-uri'
require 'Nokogiri'
require 'json'

url = 'https://www.simplyrecipes.com/recipes/ingredient/chicken/page/2/'

document = open(url)
content = document.read
parsed_content = Nokogiri::HTML(content)

recipe_links = []
parsed_content.css("a[itemprop = 'url']").each do |link|
    if link['href'].to_s.include? 'https://www.simplyrecipes.com/recipes/'
        recipe_links << link['href'].to_s
    end
end

recipes = []
recipe_links.uniq.each do |link|
  doc = open(link)
  con = doc.read
  p_con = Nokogiri::HTML(con)
  recipe_details = Hash.new
  target = p_con.at_css('div#sr-recipe-callout')
  
  cooktime = ''
  if target.at('span[class="cooktime"]')
      cooktime = target.at('span[class="cooktime"]').text
  else
      cooktime = target.at('span[class="othertime"]').text
  end
  
  if target
    recipe_details['title']       = target.css("h2").inner_text
    recipe_details['description'] = p_con.at('div[class="meta-description-content"]').text
    recipe_details['prepTime']    = target.at('span[class="preptime"]').text
    recipe_details['cookTime']    = cooktime
    recipe_details['yeild']       = target.at('span[class="yield"]').text
    recipe_details['ingredients'] = target.css('ul')[1..-1].inner_text
    recipe_details['directions']  = target.at_css('[id="sr-recipe-method"]').text
    recipe_details['image']       = p_con.css('img.photo').first.attr('src')
    recipes << recipe_details
  end
end

File.open('recipes.json', 'a+') do |f|
  f.puts JSON.pretty_generate(recipes)
end


# recipes = []
# doc = open('http://www.simplyrecipes.com/recipes/quick_macaroni_and_cheese/')
# con = doc.read
# p_con = Nokogiri::HTML(con)
# recipe_details = Hash.new
# target = p_con.at_css('div#sr-recipe-callout')
# if target
#     recipe_details['title']       = target.css('h2').inner_text
#     recipe_details['description'] = target.css('p').first.inner_text
#     recipe_details['servings']    = target.css('ul').first.inner_text
#     recipe_details['ingredients'] = target.css('ul')[1..-1].inner_text
#     recipe_details['directions']  = target.at("div[itemprop='recipeInstructions']").inner_text
#     recipe_details['image']       = p_con.css('img.wp-post-image').first.attr('src')
#     recipes << recipe_details
# end
# puts JSON.pretty_generate(recipes)
