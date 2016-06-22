MATH_SCRIPT= <<EOS
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
                           tex2jax:{
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      displayMath: [ ['$$','$$'], ["\\[","\\]"] ]
                           }
                         });
    </script>
    <script type="text/javascript"
            src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AM\
S_HTML">
    </script>
    <meta http-equiv="X-UA-Compatible" CONTENT="IE=EmulateIE7" />
EOS

ORIGINAL = <<EOS
    <%= erb(:headers) %>
  </head>
EOS
