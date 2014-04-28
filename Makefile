all: site

site:
	gitbook build \
		--github "EECS470WN14-group3/flux-documentation" \
		--title "Getting Started with Flux for EECS 470" \
		--intro "Prepared for Dr. Mark Brehob by Kyle Smith, Winter 2014" \
		--format "site"

book:
	gitbook build \
		--github "EECS470WN14-group3/flux-documentation" \
		--title "Getting Started with Flux for EECS 470" \
		--intro "Prepared for Dr. Mark Brehob by Kyle Smith, Winter 2014" \
		--format "page"
