This is a test page for the site CSS.  It contains no useful data but is rather for layout testing purposes.

Expectations of layout
------------------------

* Only 1 h1 element per page
* h2 is used for major sections
* any headers inside that are h3 followed by h4
** there should be rare if ever usage of headers 5-7
** This may change depending on syntax hilighting chosen
* Wrap all content in a div with the class "content"
** This should be done in the main Jekyll layout

Forms and Similar
-------------------
No support for forms of any kind (input etc.) have been provided.  I can't think of a use in the site this is made for.

Included are:
* input
* form
* text area

TODO
------------------------

* [DONE] Use attribute queries for different sites
** Docs links will have an icon to the right
** Forum posts will have another
** All other outbound links (not on the same site) will have another icon
*** How should GitHub links be handled?
**** Icon for GitHub should be added
**** octocat?
* Make the h1 more interesting
* Consider legend/fieldset elements
* Table support
* Extensive IE testing needed
** At the time of writing I'm crossing my fingers (no testing done on IE)
* Mobile browser testing
** Android
*** "ok" means zoom problems, "good" means best
*** Stock browser [good]
*** FireFox [ok]
*** Opera Mobile [good]

** IOS4 browser [ok]

