class TournamentsController < ApplicationController
  def show
    @tournament = Tournament.find_by_slug(params[:id])
    asciidoc = @tournament.description_asciidoc
    @description = asciidoc.nil? ? @tournament.short_description : ::Asciidoctor.render(asciidoc)
  end
end
