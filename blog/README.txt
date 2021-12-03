This folder builds a Jekyll blog for posting on Github Pages.

== Process ==

=== Drafting ===
To draft a blog post locally, create a .markdown file in the _drafts folder. To compile the Jekyll, run the batch file serve-jekyll-blog.bat and then open browser to indicated URL. Changes made to the .markdown text file will update dynamically with a refresh of the browser window.

=== Publishing ===
To publish the post, 
1. Build the revised blog tree. Move the drafted .markdown from _drafts to _posts. Then run build-jekyll-blog.bat, which will build the (revised) tree into the folder _site.
2. Move the _site folder to the web. The batch file copy-jekyll-blog.bat copies the _site folder to my local git repository.
3. Navigate to the git repository, commit, and push. Blog then posted.
