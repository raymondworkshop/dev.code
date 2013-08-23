


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>dev.mycode/localService.lua at master · muyun/dev.mycode</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <link rel="logo" type="image/svg" href="https://github-media-downloads.s3.amazonaws.com/github-logo.svg" />
    <meta property="og:image" content="https://github.global.ssl.fastly.net/images/modules/logos_page/Octocat.png">
    <meta name="hostname" content="fe13.rs.github.com">
    <meta name="ruby" content="ruby 1.9.3p194-tcs-github-tcmalloc (2012-05-25, TCS patched 2012-05-27, GitHub v1.0.32) [x86_64-linux]">
    <link rel="assets" href="https://github.global.ssl.fastly.net/">
    <link rel="xhr-socket" href="/_sockets" />
    
    


    <meta name="msapplication-TileImage" content="/windows-tile.png" />
    <meta name="msapplication-TileColor" content="#ffffff" />
    <meta name="selected-link" value="repo_source" data-pjax-transient />
    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="github" name="octolytics-app-id" /><meta content="325078" name="octolytics-actor-id" /><meta content="muyun" name="octolytics-actor-login" /><meta content="6b6505c28bfecb506dc5f673d481b06178ef123711fa9a3aa4e5ade5fe34d384" name="octolytics-actor-hash" />

    
    
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <meta content="authenticity_token" name="csrf-param" />
<meta content="cezTe6az/E1OgpJ+Fxz3stPvzYgnBxLbXTjGLaIUJXk=" name="csrf-token" />

    <link href="https://github.global.ssl.fastly.net/assets/github-3c596ae13d4be602478e6e0aea5c68650ff7df15.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://github.global.ssl.fastly.net/assets/github2-81e366db238e3dd2f41abef9af514489abb0b79e.css" media="all" rel="stylesheet" type="text/css" />
    


      <script src="https://github.global.ssl.fastly.net/assets/frameworks-c8985dfca399d9e432daeef3806abccfd050dccf.js" type="text/javascript"></script>
      <script src="https://github.global.ssl.fastly.net/assets/github-85d8fba048adf4beb94d612ecffa6b0834bb55be.js" type="text/javascript"></script>
      
      <meta http-equiv="x-pjax-version" content="81e541d750c9d23dd84857356af2ecde">

        <link data-pjax-transient rel='permalink' href='/muyun/dev.mycode/blob/a12e691eedffc59a5e98c000219eca0e1eb06726/localService.lua'>
  <meta property="og:title" content="dev.mycode"/>
  <meta property="og:type" content="githubog:gitrepository"/>
  <meta property="og:url" content="https://github.com/muyun/dev.mycode"/>
  <meta property="og:image" content="https://github.global.ssl.fastly.net/images/gravatars/gravatar-user-420.png"/>
  <meta property="og:site_name" content="GitHub"/>
  <meta property="og:description" content="dev.mycode - code exercises"/>

  <meta name="description" content="dev.mycode - code exercises" />

  <meta content="325078" name="octolytics-dimension-user_id" /><meta content="muyun" name="octolytics-dimension-user_login" /><meta content="4280813" name="octolytics-dimension-repository_id" /><meta content="muyun/dev.mycode" name="octolytics-dimension-repository_nwo" /><meta content="true" name="octolytics-dimension-repository_public" /><meta content="false" name="octolytics-dimension-repository_is_fork" /><meta content="4280813" name="octolytics-dimension-repository_network_root_id" /><meta content="muyun/dev.mycode" name="octolytics-dimension-repository_network_root_nwo" />
  <link href="https://github.com/muyun/dev.mycode/commits/master.atom" rel="alternate" title="Recent Commits to dev.mycode:master" type="application/atom+xml" />

  </head>


  <body class="logged_in page-blob linux vis-public env-production ">

    <div class="wrapper">
      
      
      


      <div class="header header-logged-in true">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/">
  <span class="mega-octicon octicon-mark-github"></span>
</a>

    <div class="divider-vertical"></div>

    
    <a href="/notifications" class="notification-indicator tooltipped downwards" data-gotokey="n" title="You have unread notifications">
        <span class="mail-status unread"></span>
</a>
  <div class="divider-vertical"></div>


      <div class="command-bar js-command-bar  in-repository">
          <form accept-charset="UTF-8" action="/search" class="command-bar-form" id="top_search_form" method="get">

<input type="text" data-hotkey="/ s" name="q" id="js-command-bar-field" placeholder="Search or type a command" tabindex="1" autocapitalize="off"
    
    data-username="muyun"
      data-repo="muyun/dev.mycode"
      data-branch="master"
      data-sha="44ac6b13388c0d5e56c8c481eff6dbb369620b4a"
  >

    <input type="hidden" name="nwo" value="muyun/dev.mycode" />

    <div class="select-menu js-menu-container js-select-menu search-context-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">This repository</span>
      </span>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">
        <div class="select-menu-modal">

          <div class="select-menu-item js-navigation-item js-this-repository-navigation-item selected">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" class="js-search-this-repository" name="search_target" value="repository" checked="checked" />
            <div class="select-menu-item-text js-select-button-text">This repository</div>
          </div> <!-- /.select-menu-item -->

          <div class="select-menu-item js-navigation-item js-all-repositories-navigation-item">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" name="search_target" value="global" />
            <div class="select-menu-item-text js-select-button-text">All repositories</div>
          </div> <!-- /.select-menu-item -->

        </div>
      </div>
    </div>

  <span class="octicon help tooltipped downwards" title="Show command bar help">
    <span class="octicon octicon-question"></span>
  </span>


  <input type="hidden" name="ref" value="cmdform">

</form>
        <ul class="top-nav">
            <li class="explore"><a href="/explore">Explore</a></li>
            <li><a href="https://gist.github.com">Gist</a></li>
            <li><a href="/blog">Blog</a></li>
            <li><a href="https://help.github.com">Help</a></li>
        </ul>
      </div>

    


  <ul id="user-links">
    <li>
      <a href="/muyun" class="name">
        <img height="20" src="https://1.gravatar.com/avatar/214142208f1b1d46592ce69043ba083b?d=https%3A%2F%2Fidenticons.github.com%2Fb4f7f92b2596a6c8943023ebd4b31d79.png&amp;s=140" width="20" /> muyun
      </a>
    </li>

      <li>
        <a href="/new" id="new_repo" class="tooltipped downwards" title="Create a new repo" aria-label="Create a new repo">
          <span class="octicon octicon-repo-create"></span>
        </a>
      </li>

      <li>
        <a href="/settings/profile" id="account_settings"
          class="tooltipped downwards"
          aria-label="Account settings "
          title="Account settings ">
          <span class="octicon octicon-tools"></span>
        </a>
      </li>
      <li>
        <a class="tooltipped downwards" href="/logout" data-method="post" id="logout" title="Sign out" aria-label="Sign out">
          <span class="octicon octicon-log-out"></span>
        </a>
      </li>

  </ul>

<div class="js-new-dropdown-contents hidden">
  

<ul class="dropdown-menu">
  <li>
    <a href="/new"><span class="octicon octicon-repo-create"></span> New repository</a>
  </li>
  <li>
    <a href="/organizations/new"><span class="octicon octicon-organization"></span> New organization</a>
  </li>



    <li class="section-title">
      <span title="muyun/dev.mycode">This repository</span>
    </li>
    <li>
      <a href="/muyun/dev.mycode/issues/new"><span class="octicon octicon-issue-opened"></span> New issue</a>
    </li>
      <li>
        <a href="/muyun/dev.mycode/settings/collaboration"><span class="octicon octicon-person-add"></span> New collaborator</a>
      </li>
</ul>

</div>


    
  </div>
</div>

      

      




          <div class="site" itemscope itemtype="http://schema.org/WebPage">
    
    <div class="pagehead repohead instapaper_ignore readability-menu">
      <div class="container">
        

<ul class="pagehead-actions">

    <li class="subscription">
      <form accept-charset="UTF-8" action="/notifications/subscribe" class="js-social-container" data-autosubmit="true" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="cezTe6az/E1OgpJ+Fxz3stPvzYgnBxLbXTjGLaIUJXk=" /></div>  <input id="repository_id" name="repository_id" type="hidden" value="4280813" />

    <div class="select-menu js-menu-container js-select-menu">
        <a class="social-count js-social-count" href="/muyun/dev.mycode/watchers">
          1
        </a>
      <span class="minibutton select-menu-button with-count js-menu-target">
        <span class="js-select-button">
          <span class="octicon octicon-eye-unwatch"></span>
          Unwatch
        </span>
      </span>

      <div class="select-menu-modal-holder">
        <div class="select-menu-modal subscription-menu-modal js-menu-content">
          <div class="select-menu-header">
            <span class="select-menu-title">Notification status</span>
            <span class="octicon octicon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-list js-navigation-container">

            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_included" name="do" type="radio" value="included" />
                <h4>Not watching</h4>
                <span class="description">You only receive notifications for discussions in which you participate or are @mentioned.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-watch"></span>
                  Watch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item selected">
              <span class="select-menu-item-icon octicon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input checked="checked" id="do_subscribed" name="do" type="radio" value="subscribed" />
                <h4>Watching</h4>
                <span class="description">You receive notifications for all discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-unwatch"></span>
                  Unwatch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_ignore" name="do" type="radio" value="ignore" />
                <h4>Ignoring</h4>
                <span class="description">You do not receive any notifications for discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-mute"></span>
                  Stop ignoring
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

</form>
    </li>

  <li>
  
<div class="js-toggler-container js-social-container starring-container ">
  <a href="/muyun/dev.mycode/unstar" class="minibutton with-count js-toggler-target star-button starred upwards" title="Unstar this repo" data-remote="true" data-method="post" rel="nofollow">
    <span class="octicon octicon-star-delete"></span><span class="text">Unstar</span>
  </a>
  <a href="/muyun/dev.mycode/star" class="minibutton with-count js-toggler-target star-button unstarred upwards" title="Star this repo" data-remote="true" data-method="post" rel="nofollow">
    <span class="octicon octicon-star"></span><span class="text">Star</span>
  </a>
  <a class="social-count js-social-count" href="/muyun/dev.mycode/stargazers">0</a>
</div>

  </li>


        <li>
          <a href="/muyun/dev.mycode/fork" class="minibutton with-count js-toggler-target fork-button lighter upwards" title="Fork this repo" rel="nofollow" data-method="post">
            <span class="octicon octicon-git-branch-create"></span><span class="text">Fork</span>
          </a>
          <a href="/muyun/dev.mycode/network" class="social-count">0</a>
        </li>


</ul>

        <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
          <span class="repo-label"><span>public</span></span>
          <span class="mega-octicon octicon-repo"></span>
          <span class="author">
            <a href="/muyun" class="url fn" itemprop="url" rel="author"><span itemprop="title">muyun</span></a></span
          ><span class="repohead-name-divider">/</span><strong
          ><a href="/muyun/dev.mycode" class="js-current-repository js-repo-home-link">dev.mycode</a></strong>

          <span class="page-context-loader">
            <img alt="Octocat-spinner-32" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
          </span>

        </h1>
      </div><!-- /.container -->
    </div><!-- /.repohead -->

    <div class="container">

      <div class="repository-with-sidebar repo-container ">

        <div class="repository-sidebar">
            

<div class="repo-nav repo-nav-full js-repository-container-pjax js-octicon-loaders">
  <div class="repo-nav-contents">
    <ul class="repo-menu">
      <li class="tooltipped leftwards" title="Code">
        <a href="/muyun/dev.mycode" aria-label="Code" class="js-selected-navigation-item selected" data-gotokey="c" data-pjax="true" data-selected-links="repo_source repo_downloads repo_commits repo_tags repo_branches /muyun/dev.mycode">
          <span class="octicon octicon-code"></span> <span class="full-word">Code</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

        <li class="tooltipped leftwards" title="Issues">
          <a href="/muyun/dev.mycode/issues" aria-label="Issues" class="js-selected-navigation-item js-disable-pjax" data-gotokey="i" data-selected-links="repo_issues /muyun/dev.mycode/issues">
            <span class="octicon octicon-issue-opened"></span> <span class="full-word">Issues</span>
            <span class='counter'>0</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>        </li>

      <li class="tooltipped leftwards" title="Pull Requests"><a href="/muyun/dev.mycode/pulls" aria-label="Pull Requests" class="js-selected-navigation-item js-disable-pjax" data-gotokey="p" data-selected-links="repo_pulls /muyun/dev.mycode/pulls">
            <span class="octicon octicon-git-pull-request"></span> <span class="full-word">Pull Requests</span>
            <span class='counter'>0</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>


        <li class="tooltipped leftwards" title="Wiki">
          <a href="/muyun/dev.mycode/wiki" aria-label="Wiki" class="js-selected-navigation-item " data-pjax="true" data-selected-links="repo_wiki /muyun/dev.mycode/wiki">
            <span class="octicon octicon-book"></span> <span class="full-word">Wiki</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>        </li>
    </ul>
    <div class="repo-menu-separator"></div>
    <ul class="repo-menu">

      <li class="tooltipped leftwards" title="Pulse">
        <a href="/muyun/dev.mycode/pulse" aria-label="Pulse" class="js-selected-navigation-item " data-pjax="true" data-selected-links="pulse /muyun/dev.mycode/pulse">
          <span class="octicon octicon-pulse"></span> <span class="full-word">Pulse</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

      <li class="tooltipped leftwards" title="Graphs">
        <a href="/muyun/dev.mycode/graphs" aria-label="Graphs" class="js-selected-navigation-item " data-pjax="true" data-selected-links="repo_graphs repo_contributors /muyun/dev.mycode/graphs">
          <span class="octicon octicon-graph"></span> <span class="full-word">Graphs</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

      <li class="tooltipped leftwards" title="Network">
        <a href="/muyun/dev.mycode/network" aria-label="Network" class="js-selected-navigation-item js-disable-pjax" data-selected-links="repo_network /muyun/dev.mycode/network">
          <span class="octicon octicon-git-branch"></span> <span class="full-word">Network</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

    </ul>

      <div class="repo-menu-separator"></div>
      <ul class="repo-menu">
        <li class="tooltipped leftwards" title="Settings">
          <a href="/muyun/dev.mycode/settings" data-pjax aria-label="Settings">
            <span class="octicon octicon-tools"></span> <span class="full-word">Settings</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
          </a>
        </li>
      </ul>
  </div>
</div>

            <div class="only-with-full-nav">
              

  

<div class="clone-url open"
  data-protocol-type="http"
  data-url="/users/set_protocol?protocol_selector=http&amp;protocol_type=push">
  <h3><strong>HTTPS</strong> clone URL</h3>

  <input type="text" class="clone js-url-field"
         value="https://github.com/muyun/dev.mycode.git" readonly="readonly">

  <span class="js-zeroclipboard url-box-clippy minibutton zeroclipboard-button" data-clipboard-text="https://github.com/muyun/dev.mycode.git" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
</div>

  

<div class="clone-url "
  data-protocol-type="ssh"
  data-url="/users/set_protocol?protocol_selector=ssh&amp;protocol_type=push">
  <h3><strong>SSH</strong> clone URL</h3>

  <input type="text" class="clone js-url-field"
         value="git@github.com:muyun/dev.mycode.git" readonly="readonly">

  <span class="js-zeroclipboard url-box-clippy minibutton zeroclipboard-button" data-clipboard-text="git@github.com:muyun/dev.mycode.git" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
</div>

  

<div class="clone-url "
  data-protocol-type="subversion"
  data-url="/users/set_protocol?protocol_selector=subversion&amp;protocol_type=push">
  <h3><strong>Subversion</strong> checkout URL</h3>

  <input type="text" class="clone js-url-field"
         value="https://github.com/muyun/dev.mycode" readonly="readonly">

  <span class="js-zeroclipboard url-box-clippy minibutton zeroclipboard-button" data-clipboard-text="https://github.com/muyun/dev.mycode" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
</div>



<p class="clone-options">You can clone with
    <a href="#" class="js-clone-selector" data-protocol="http">HTTPS</a>,
    <a href="#" class="js-clone-selector" data-protocol="ssh">SSH</a>,
    <a href="#" class="js-clone-selector" data-protocol="subversion">Subversion</a>,
  and <a href="https://help.github.com/articles/which-remote-url-should-i-use">other methods.</a>
</p>



                <a href="/muyun/dev.mycode/archive/master.zip"
                   class="minibutton sidebar-button"
                   title="Download this repository as a zip file"
                   rel="nofollow">
                  <span class="octicon octicon-cloud-download"></span>
                  Download ZIP
                </a>
            </div>
        </div><!-- /.repository-sidebar -->

        <div id="js-repo-pjax-container" class="repository-content context-loader-container" data-pjax-container>
          


<!-- blob contrib key: blob_contributors:v21:255c7f913f5e3fa350129c18f34f2b66 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:255c7f913f5e3fa350129c18f34f2b66 -->

<p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

<a href="/muyun/dev.mycode/find/master" data-pjax data-hotkey="t" style="display:none">Show File Finder</a>

<div class="file-navigation">
  


<div class="select-menu js-menu-container js-select-menu" >
  <span class="minibutton select-menu-button js-menu-target" data-hotkey="w"
    data-master-branch="master"
    data-ref="master">
    <span class="octicon octicon-git-branch"></span>
    <i>branch:</i>
    <span class="js-select-button">master</span>
  </span>

  <div class="select-menu-modal-holder js-menu-content js-navigation-container" data-pjax>

    <div class="select-menu-modal">
      <div class="select-menu-header">
        <span class="select-menu-title">Switch branches/tags</span>
        <span class="octicon octicon-remove-close js-menu-close"></span>
      </div> <!-- /.select-menu-header -->

      <div class="select-menu-filters">
        <div class="select-menu-text-filter">
          <input type="text" id="context-commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Find or create a branch…">
        </div>
        <div class="select-menu-tabs">
          <ul>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
            </li>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
            </li>
          </ul>
        </div><!-- /.select-menu-tabs -->
      </div><!-- /.select-menu-filters -->

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="branches">

        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <div class="select-menu-item js-navigation-item selected">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <a href="/muyun/dev.mycode/blob/master/localService.lua" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" data-skip-pjax="true" rel="nofollow" title="master">master</a>
            </div> <!-- /.select-menu-item -->
        </div>

          <form accept-charset="UTF-8" action="/muyun/dev.mycode/branches" class="js-create-branch select-menu-item select-menu-new-item-form js-navigation-item js-new-item-form" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="cezTe6az/E1OgpJ+Fxz3stPvzYgnBxLbXTjGLaIUJXk=" /></div>
            <span class="octicon octicon-git-branch-create select-menu-item-icon"></span>
            <div class="select-menu-item-text">
              <h4>Create branch: <span class="js-new-item-name"></span></h4>
              <span class="description">from ‘master’</span>
            </div>
            <input type="hidden" name="name" id="name" class="js-new-item-value">
            <input type="hidden" name="branch" id="branch" value="master" />
            <input type="hidden" name="path" id="branch" value="localService.lua" />
          </form> <!-- /.select-menu-item -->

      </div> <!-- /.select-menu-list -->

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="tags">
        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


        </div>

        <div class="select-menu-no-results">Nothing to show</div>
      </div> <!-- /.select-menu-list -->

    </div> <!-- /.select-menu-modal -->
  </div> <!-- /.select-menu-modal-holder -->
</div> <!-- /.select-menu -->

  <div class="breadcrumb">
    <span class='repo-root js-repo-root'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/muyun/dev.mycode" data-branch="master" data-direction="back" data-pjax="true" itemscope="url"><span itemprop="title">dev.mycode</span></a></span></span><span class="separator"> / </span><strong class="final-path">localService.lua</strong> <span class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="localService.lua" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
  </div>
</div>


  
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://1.gravatar.com/avatar/214142208f1b1d46592ce69043ba083b?d=https%3A%2F%2Fidenticons.github.com%2Fb4f7f92b2596a6c8943023ebd4b31d79.png&amp;s=140" width="24" />
    <span class="author"><a href="/muyun" rel="author">muyun</a></span>
    <time class="js-relative-date" datetime="2012-10-19T12:02:07-07:00" title="2012-10-19 12:02:07">October 19, 2012</time>
    <div class="commit-title">
        <a href="/muyun/dev.mycode/commit/9bcb97b17eecf9bac88e3cd820026c0c605017bb" class="message" data-pjax="true" title="correct some errors when the code is running in corona env">correct some errors when the code is running in corona env</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>1</strong> contributor</a></p>
      
    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2 class="facebox-header">Users who have contributed to this file</h2>
      <ul class="facebox-user-list">
        <li class="facebox-user-list-item">
          <img height="24" src="https://1.gravatar.com/avatar/214142208f1b1d46592ce69043ba083b?d=https%3A%2F%2Fidenticons.github.com%2Fb4f7f92b2596a6c8943023ebd4b31d79.png&amp;s=140" width="24" />
          <a href="/muyun">muyun</a>
        </li>
      </ul>
    </div>
  </div>


<div id="files" class="bubble">
  <div class="file">
    <div class="meta">
      <div class="info">
        <span class="icon"><b class="octicon octicon-file-text"></b></span>
        <span class="mode" title="File Mode">file</span>
          <span>260 lines (170 sloc)</span>
        <span>7.33 kb</span>
      </div>
      <div class="actions">
        <div class="button-group">
                <a class="minibutton"
                   href="/muyun/dev.mycode/edit/master/localService.lua"
                   data-method="post" rel="nofollow" data-hotkey="e">Edit</a>
          <a href="/muyun/dev.mycode/raw/master/localService.lua" class="button minibutton " id="raw-url">Raw</a>
            <a href="/muyun/dev.mycode/blame/master/localService.lua" class="button minibutton ">Blame</a>
          <a href="/muyun/dev.mycode/commits/master/localService.lua" class="button minibutton " rel="nofollow">History</a>
        </div><!-- /.button-group -->
            <a class="minibutton danger empty-icon tooltipped downwards"
               href="/muyun/dev.mycode/delete/master/localService.lua"
               title=""
               data-method="post" data-test-id="delete-blob-file" rel="nofollow">
            Delete
          </a>
      </div><!-- /.actions -->

    </div>
        <div class="blob-wrapper data type-lua js-blob-data">
        <table class="file-code file-diff">
          <tr class="file-code-line">
            <td class="blob-line-nums">
              <span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>
<span id="L109" rel="#L109">109</span>
<span id="L110" rel="#L110">110</span>
<span id="L111" rel="#L111">111</span>
<span id="L112" rel="#L112">112</span>
<span id="L113" rel="#L113">113</span>
<span id="L114" rel="#L114">114</span>
<span id="L115" rel="#L115">115</span>
<span id="L116" rel="#L116">116</span>
<span id="L117" rel="#L117">117</span>
<span id="L118" rel="#L118">118</span>
<span id="L119" rel="#L119">119</span>
<span id="L120" rel="#L120">120</span>
<span id="L121" rel="#L121">121</span>
<span id="L122" rel="#L122">122</span>
<span id="L123" rel="#L123">123</span>
<span id="L124" rel="#L124">124</span>
<span id="L125" rel="#L125">125</span>
<span id="L126" rel="#L126">126</span>
<span id="L127" rel="#L127">127</span>
<span id="L128" rel="#L128">128</span>
<span id="L129" rel="#L129">129</span>
<span id="L130" rel="#L130">130</span>
<span id="L131" rel="#L131">131</span>
<span id="L132" rel="#L132">132</span>
<span id="L133" rel="#L133">133</span>
<span id="L134" rel="#L134">134</span>
<span id="L135" rel="#L135">135</span>
<span id="L136" rel="#L136">136</span>
<span id="L137" rel="#L137">137</span>
<span id="L138" rel="#L138">138</span>
<span id="L139" rel="#L139">139</span>
<span id="L140" rel="#L140">140</span>
<span id="L141" rel="#L141">141</span>
<span id="L142" rel="#L142">142</span>
<span id="L143" rel="#L143">143</span>
<span id="L144" rel="#L144">144</span>
<span id="L145" rel="#L145">145</span>
<span id="L146" rel="#L146">146</span>
<span id="L147" rel="#L147">147</span>
<span id="L148" rel="#L148">148</span>
<span id="L149" rel="#L149">149</span>
<span id="L150" rel="#L150">150</span>
<span id="L151" rel="#L151">151</span>
<span id="L152" rel="#L152">152</span>
<span id="L153" rel="#L153">153</span>
<span id="L154" rel="#L154">154</span>
<span id="L155" rel="#L155">155</span>
<span id="L156" rel="#L156">156</span>
<span id="L157" rel="#L157">157</span>
<span id="L158" rel="#L158">158</span>
<span id="L159" rel="#L159">159</span>
<span id="L160" rel="#L160">160</span>
<span id="L161" rel="#L161">161</span>
<span id="L162" rel="#L162">162</span>
<span id="L163" rel="#L163">163</span>
<span id="L164" rel="#L164">164</span>
<span id="L165" rel="#L165">165</span>
<span id="L166" rel="#L166">166</span>
<span id="L167" rel="#L167">167</span>
<span id="L168" rel="#L168">168</span>
<span id="L169" rel="#L169">169</span>
<span id="L170" rel="#L170">170</span>
<span id="L171" rel="#L171">171</span>
<span id="L172" rel="#L172">172</span>
<span id="L173" rel="#L173">173</span>
<span id="L174" rel="#L174">174</span>
<span id="L175" rel="#L175">175</span>
<span id="L176" rel="#L176">176</span>
<span id="L177" rel="#L177">177</span>
<span id="L178" rel="#L178">178</span>
<span id="L179" rel="#L179">179</span>
<span id="L180" rel="#L180">180</span>
<span id="L181" rel="#L181">181</span>
<span id="L182" rel="#L182">182</span>
<span id="L183" rel="#L183">183</span>
<span id="L184" rel="#L184">184</span>
<span id="L185" rel="#L185">185</span>
<span id="L186" rel="#L186">186</span>
<span id="L187" rel="#L187">187</span>
<span id="L188" rel="#L188">188</span>
<span id="L189" rel="#L189">189</span>
<span id="L190" rel="#L190">190</span>
<span id="L191" rel="#L191">191</span>
<span id="L192" rel="#L192">192</span>
<span id="L193" rel="#L193">193</span>
<span id="L194" rel="#L194">194</span>
<span id="L195" rel="#L195">195</span>
<span id="L196" rel="#L196">196</span>
<span id="L197" rel="#L197">197</span>
<span id="L198" rel="#L198">198</span>
<span id="L199" rel="#L199">199</span>
<span id="L200" rel="#L200">200</span>
<span id="L201" rel="#L201">201</span>
<span id="L202" rel="#L202">202</span>
<span id="L203" rel="#L203">203</span>
<span id="L204" rel="#L204">204</span>
<span id="L205" rel="#L205">205</span>
<span id="L206" rel="#L206">206</span>
<span id="L207" rel="#L207">207</span>
<span id="L208" rel="#L208">208</span>
<span id="L209" rel="#L209">209</span>
<span id="L210" rel="#L210">210</span>
<span id="L211" rel="#L211">211</span>
<span id="L212" rel="#L212">212</span>
<span id="L213" rel="#L213">213</span>
<span id="L214" rel="#L214">214</span>
<span id="L215" rel="#L215">215</span>
<span id="L216" rel="#L216">216</span>
<span id="L217" rel="#L217">217</span>
<span id="L218" rel="#L218">218</span>
<span id="L219" rel="#L219">219</span>
<span id="L220" rel="#L220">220</span>
<span id="L221" rel="#L221">221</span>
<span id="L222" rel="#L222">222</span>
<span id="L223" rel="#L223">223</span>
<span id="L224" rel="#L224">224</span>
<span id="L225" rel="#L225">225</span>
<span id="L226" rel="#L226">226</span>
<span id="L227" rel="#L227">227</span>
<span id="L228" rel="#L228">228</span>
<span id="L229" rel="#L229">229</span>
<span id="L230" rel="#L230">230</span>
<span id="L231" rel="#L231">231</span>
<span id="L232" rel="#L232">232</span>
<span id="L233" rel="#L233">233</span>
<span id="L234" rel="#L234">234</span>
<span id="L235" rel="#L235">235</span>
<span id="L236" rel="#L236">236</span>
<span id="L237" rel="#L237">237</span>
<span id="L238" rel="#L238">238</span>
<span id="L239" rel="#L239">239</span>
<span id="L240" rel="#L240">240</span>
<span id="L241" rel="#L241">241</span>
<span id="L242" rel="#L242">242</span>
<span id="L243" rel="#L243">243</span>
<span id="L244" rel="#L244">244</span>
<span id="L245" rel="#L245">245</span>
<span id="L246" rel="#L246">246</span>
<span id="L247" rel="#L247">247</span>
<span id="L248" rel="#L248">248</span>
<span id="L249" rel="#L249">249</span>
<span id="L250" rel="#L250">250</span>
<span id="L251" rel="#L251">251</span>
<span id="L252" rel="#L252">252</span>
<span id="L253" rel="#L253">253</span>
<span id="L254" rel="#L254">254</span>
<span id="L255" rel="#L255">255</span>
<span id="L256" rel="#L256">256</span>
<span id="L257" rel="#L257">257</span>
<span id="L258" rel="#L258">258</span>
<span id="L259" rel="#L259">259</span>

            </td>
            <td class="blob-line-code">
                    <div class="highlight"><pre><div class='line' id='LC1'><span class="c1">--#!/c:/lua5.1/lua.exe</span></div><div class='line' id='LC2'><span class="c1">---</span></div><div class='line' id='LC3'><span class="c1">---This is a homework in Mobile Application course in CUHK, written by zhaowenlong----</span></div><div class='line' id='LC4'><span class="c1">---The function is to display all users&#39;s location based on user&#39;s location on screen ----</span></div><div class='line' id='LC5'><span class="c1">---It is built on Corona middle layer</span></div><div class='line' id='LC6'><br/></div><div class='line' id='LC7'><br/></div><div class='line' id='LC8'><span class="k">function</span> <span class="nf">constructData</span> <span class="p">()</span></div><div class='line' id='LC9'><br/></div><div class='line' id='LC10'>	     <span class="c1">--download</span></div><div class='line' id='LC11'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--Check whether the file exists, if yes, remove it</span></div><div class='line' id='LC12'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kd">local</span> <span class="n">path</span> <span class="o">=</span> <span class="n">system</span><span class="p">.</span><span class="n">pathForFile</span><span class="p">(</span>  <span class="s2">&quot;</span><span class="s">pos.txt&quot;</span><span class="p">,</span> <span class="n">system</span><span class="p">.</span><span class="n">DocumentsDirectory</span> <span class="p">)</span></div><div class='line' id='LC13'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kd">local</span> <span class="n">fhd</span> <span class="o">=</span> <span class="nb">io.open</span><span class="p">(</span> <span class="n">path</span> <span class="p">)</span></div><div class='line' id='LC14'><br/></div><div class='line' id='LC15'>	    <span class="k">if</span> <span class="n">fhd</span> <span class="k">then</span></div><div class='line' id='LC16'><br/></div><div class='line' id='LC17'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">print</span><span class="p">(</span> <span class="s2">&quot;</span><span class="s">File pos.txt exists&quot;</span> <span class="p">)</span></div><div class='line' id='LC18'>			 <span class="nb">print</span><span class="p">(</span> <span class="s2">&quot;</span><span class="s">Remove it&quot;</span><span class="p">)</span></div><div class='line' id='LC19'><br/></div><div class='line' id='LC20'>	         <span class="c1">--fhd.close()</span></div><div class='line' id='LC21'><br/></div><div class='line' id='LC22'>	         <span class="kd">local</span> <span class="n">results</span><span class="p">,</span> <span class="n">reason</span> <span class="o">=</span> <span class="nb">os.remove</span><span class="p">(</span> <span class="n">path</span> <span class="p">)</span></div><div class='line' id='LC23'><br/></div><div class='line' id='LC24'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC25'><br/></div><div class='line' id='LC26'>	         <span class="c1">-- read the data file downloaded and parse it</span></div><div class='line' id='LC27'><br/></div><div class='line' id='LC28'>		<span class="kd">local</span>  <span class="n">MaxLongitude</span><span class="p">,</span><span class="n">MaxLatitude</span> <span class="o">=</span> <span class="mi">0</span><span class="p">,</span><span class="mi">0</span></div><div class='line' id='LC29'>		<span class="kd">local</span> <span class="n">userLongitude</span><span class="p">,</span><span class="n">userlatitude</span><span class="p">,</span><span class="n">relativeLongitude</span><span class="p">,</span><span class="n">relativeLatitude</span> <span class="o">=</span> <span class="mi">0</span><span class="p">,</span> <span class="mi">0</span><span class="p">,</span> <span class="mi">0</span><span class="p">,</span> <span class="mi">0</span></div><div class='line' id='LC30'><br/></div><div class='line' id='LC31'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--  local filename = &quot;d:/Dropbox/workspace/mobileApp/locService/pos.txt&quot;</span></div><div class='line' id='LC32'><br/></div><div class='line' id='LC33'>		<span class="c1">-- i is used to remember the user id</span></div><div class='line' id='LC34'>		<span class="kd">local</span> <span class="n">i</span> <span class="o">=</span> <span class="mi">0</span></div><div class='line' id='LC35'><br/></div><div class='line' id='LC36'>		<span class="k">for</span>  <span class="n">line</span> <span class="k">in</span> <span class="nb">io.lines</span><span class="p">(</span><span class="n">path</span><span class="p">)</span>  <span class="k">do</span></div><div class='line' id='LC37'><br/></div><div class='line' id='LC38'>			<span class="n">i</span> <span class="o">=</span> <span class="n">i</span> <span class="o">+</span> <span class="mi">1</span></div><div class='line' id='LC39'>			<span class="c1">--print(&quot;line:&quot; ..line)</span></div><div class='line' id='LC40'>		    <span class="kd">local</span> <span class="n">_</span><span class="p">,</span><span class="n">_</span><span class="p">,</span><span class="n">id</span><span class="p">,</span><span class="n">name</span><span class="p">,</span><span class="n">longitude</span><span class="p">,</span><span class="n">latitude</span><span class="p">,</span><span class="n">altitude</span><span class="o">=</span> <span class="nb">string.find</span><span class="p">(</span><span class="n">line</span><span class="p">,</span> <span class="s2">&quot;</span><span class="s">(%d+)%s+(%w+)%s+([-+]?[0-9]*\.?[0-9]*)%s+([-+]?[0-9]*\.?[0-9]*)%s+([^%s]+)&quot;</span><span class="p">)</span></div><div class='line' id='LC41'>			 <span class="c1">--local id,name,longitude,latitude = 1,&quot;s0123456789&quot;,13, 0.598</span></div><div class='line' id='LC42'><br/></div><div class='line' id='LC43'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">print</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">id:&quot;</span> <span class="o">..</span> <span class="n">id</span> <span class="o">..</span> <span class="s2">&quot;</span><span class="s">,name:&quot;</span> <span class="o">..</span> <span class="n">name</span> <span class="o">..</span> <span class="s2">&quot;</span><span class="s">,longitude:&quot;</span> <span class="o">..</span> <span class="n">longitude</span> <span class="o">..</span> <span class="s2">&quot;</span><span class="s">,latitude:&quot;</span> <span class="o">..</span> <span class="n">latitude</span><span class="p">)</span></div><div class='line' id='LC44'><br/></div><div class='line' id='LC45'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--construct the Bounding box based on maximum and Minimum</span></div><div class='line' id='LC46'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">----which means that if the furthest user can be shown, all users can be shown</span></div><div class='line' id='LC47'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">----get Maximum x, y coordinates and Minimum x, y coordinates</span></div><div class='line' id='LC48'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">longitude</span> <span class="o">=</span><span class="nb">tonumber</span><span class="p">(</span><span class="n">longitude</span><span class="p">)</span></div><div class='line' id='LC49'>		    <span class="k">if</span> <span class="nb">math.abs</span><span class="p">(</span><span class="n">longitude</span><span class="p">)</span> <span class="o">&gt;=</span> <span class="n">MaxLongitude</span> <span class="k">then</span></div><div class='line' id='LC50'>			     <span class="n">MaxLongitude</span> <span class="o">=</span> <span class="nb">math.abs</span><span class="p">(</span><span class="n">longitude</span><span class="p">)</span></div><div class='line' id='LC51'>		    <span class="k">end</span></div><div class='line' id='LC52'><br/></div><div class='line' id='LC53'>		     <span class="c1">--print(&quot;longitude:&quot; .. longitude .. &quot;,MaxLongitude:&quot; ..MaxLongitude)</span></div><div class='line' id='LC54'><br/></div><div class='line' id='LC55'>		    <span class="n">latitude</span> <span class="o">=</span><span class="nb">tonumber</span><span class="p">(</span><span class="n">latitude</span><span class="p">)</span></div><div class='line' id='LC56'>		    <span class="k">if</span> <span class="nb">math.abs</span><span class="p">(</span><span class="n">latitude</span><span class="p">)</span> <span class="o">&gt;=</span> <span class="n">MaxLatitude</span> <span class="k">then</span></div><div class='line' id='LC57'>		         <span class="n">MaxLatitude</span> <span class="o">=</span> <span class="nb">math.abs</span><span class="p">(</span><span class="n">latitude</span><span class="p">)</span></div><div class='line' id='LC58'>		    <span class="k">end</span></div><div class='line' id='LC59'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--print(&quot;latitude:&quot; .. latitude .. &quot;,MaxLatitude:&quot; ..MaxLatitude)</span></div><div class='line' id='LC60'><br/></div><div class='line' id='LC61'><br/></div><div class='line' id='LC62'>			 <span class="c1">----find the relative location</span></div><div class='line' id='LC63'><br/></div><div class='line' id='LC64'>			 <span class="k">if</span> <span class="n">i</span> <span class="o">==</span> <span class="mi">1</span> <span class="k">then</span></div><div class='line' id='LC65'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">userLongitude</span> <span class="o">=</span> <span class="n">longitude</span></div><div class='line' id='LC66'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">userlatitude</span> <span class="o">=</span> <span class="n">latitude</span></div><div class='line' id='LC67'><br/></div><div class='line' id='LC68'>				 <span class="n">relativeLongitude</span> <span class="o">=</span> <span class="n">longitude</span></div><div class='line' id='LC69'>				 <span class="n">relativeLatitude</span> <span class="o">=</span> <span class="n">latitude</span></div><div class='line' id='LC70'>			 <span class="k">else</span></div><div class='line' id='LC71'>			     <span class="n">relativeLongitude</span> <span class="o">=</span> <span class="n">longitude</span> <span class="o">-</span> <span class="n">userLongitude</span></div><div class='line' id='LC72'>				 <span class="n">relativeLatitude</span> <span class="o">=</span> <span class="n">latitude</span> <span class="o">-</span> <span class="n">userlatitude</span></div><div class='line' id='LC73'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC74'><br/></div><div class='line' id='LC75'>		     <span class="c1">----construct the data</span></div><div class='line' id='LC76'>			 <span class="n">id</span><span class="o">=</span><span class="nb">tonumber</span><span class="p">(</span><span class="n">id</span><span class="p">)</span></div><div class='line' id='LC77'>		    <span class="n">userinfo</span><span class="p">[</span><span class="n">i</span><span class="p">]</span> <span class="o">=</span> <span class="p">{</span> <span class="n">id</span><span class="p">,</span> <span class="n">name</span><span class="p">,</span><span class="n">latitude</span><span class="p">,</span> <span class="n">longitude</span><span class="p">,</span><span class="n">relativeLatitude</span><span class="p">,</span><span class="n">relativeLongitude</span><span class="p">}</span></div><div class='line' id='LC78'><br/></div><div class='line' id='LC79'>		    <span class="c1">--print(&quot;getid:&quot; .. id .. &quot;,name:&quot; .. name .. &quot;,longitude:&quot; .. longitude .. &quot;,latitude:&quot; .. latitude)</span></div><div class='line' id='LC80'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--print(&quot;relativeLatitude:&quot; .. relativeLatitude .. &quot;,relativeLongitude:&quot; .. relativeLongitude .. &quot;,userinfo:&quot; .. #userinfo)</span></div><div class='line' id='LC81'>		 <span class="k">end</span></div><div class='line' id='LC82'><br/></div><div class='line' id='LC83'>	  <span class="c1">--print(&quot;MaxLongitude:&quot; .. MaxLongitude .. &quot;,MaxLatitude:&quot; .. MaxLatitude)</span></div><div class='line' id='LC84'><br/></div><div class='line' id='LC85'>		 <span class="c1">-- store the max info in table configinfo</span></div><div class='line' id='LC86'>	 <span class="n">configinfo</span> <span class="o">=</span><span class="p">{</span><span class="n">MaxLatitude</span><span class="p">,</span><span class="n">MaxLongitude</span><span class="p">}</span></div><div class='line' id='LC87'><br/></div><div class='line' id='LC88'><span class="k">end</span></div><div class='line' id='LC89'><br/></div><div class='line' id='LC90'><span class="k">function</span> <span class="nf">tapListener1</span><span class="p">(</span><span class="n">event</span><span class="p">)</span></div><div class='line' id='LC91'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">print</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">display the circles&quot;</span><span class="p">)</span></div><div class='line' id='LC92'>		 <span class="n">circle</span><span class="p">:</span><span class="n">removeEventListener</span><span class="p">(</span> <span class="s2">&quot;</span><span class="s">tap&quot;</span><span class="p">,</span> <span class="n">tapListener1</span> <span class="p">)</span></div><div class='line' id='LC93'><br/></div><div class='line' id='LC94'>		 <span class="c1">--addListener2 is used to remove the text on screen</span></div><div class='line' id='LC95'>		 <span class="n">timer</span><span class="p">:</span><span class="n">performWithDelay</span><span class="p">(</span> <span class="mi">1</span><span class="p">,</span> <span class="n">addListener2</span> <span class="p">)</span></div><div class='line' id='LC96'>		 <span class="k">return</span> <span class="kc">true</span></div><div class='line' id='LC97'><span class="k">end</span></div><div class='line' id='LC98'><br/></div><div class='line' id='LC99'><br/></div><div class='line' id='LC100'><span class="k">function</span> <span class="nf">tapListener</span><span class="p">(</span><span class="n">event</span><span class="p">)</span></div><div class='line' id='LC101'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">print</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">remove the name on screen&quot;</span><span class="p">)</span></div><div class='line' id='LC102'><br/></div><div class='line' id='LC103'>		<span class="k">if</span> <span class="n">circle</span><span class="p">.</span><span class="n">name</span> <span class="o">~=</span> <span class="kc">nil</span> <span class="k">then</span></div><div class='line' id='LC104'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">circle</span><span class="p">.</span><span class="n">name</span><span class="p">.</span><span class="n">isVisible</span> <span class="o">=</span> <span class="kc">false</span></div><div class='line' id='LC105'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC106'><br/></div><div class='line' id='LC107'>		 <span class="c1">--The text will be displayed for 5 seconds, and removed</span></div><div class='line' id='LC108'>		 <span class="n">timer</span><span class="p">:</span><span class="n">performWithDelay</span><span class="p">(</span> <span class="mi">5000</span><span class="p">,</span> <span class="n">tapListener</span> <span class="p">)</span></div><div class='line' id='LC109'><br/></div><div class='line' id='LC110'><br/></div><div class='line' id='LC111'>		 <span class="k">return</span> <span class="kc">true</span></div><div class='line' id='LC112'><span class="k">end</span></div><div class='line' id='LC113'><br/></div><div class='line' id='LC114'><span class="k">function</span> <span class="nf">addListener</span><span class="p">()</span></div><div class='line' id='LC115'>		<span class="n">circle</span><span class="p">:</span><span class="n">addEventListener</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">tap&quot;</span><span class="p">,</span> <span class="n">tapListener</span><span class="p">)</span></div><div class='line' id='LC116'><br/></div><div class='line' id='LC117'><span class="k">end</span></div><div class='line' id='LC118'><br/></div><div class='line' id='LC119'><span class="c1">--addListener2 is used to remove the text on screen</span></div><div class='line' id='LC120'><span class="k">function</span> <span class="nf">addListener2</span><span class="p">()</span></div><div class='line' id='LC121'><br/></div><div class='line' id='LC122'>		 <span class="n">circle</span><span class="p">:</span><span class="n">addListener2</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">tap&quot;</span><span class="p">,</span><span class="n">tapListener2</span><span class="p">)</span></div><div class='line' id='LC123'><br/></div><div class='line' id='LC124'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--timer.performWithDelay( 1, addListener2 )</span></div><div class='line' id='LC125'>		 <span class="k">return</span> <span class="kc">true</span></div><div class='line' id='LC126'><span class="k">end</span></div><div class='line' id='LC127'><br/></div><div class='line' id='LC128'><br/></div><div class='line' id='LC129'><span class="c1">-- construct the bounding box</span></div><div class='line' id='LC130'><span class="k">function</span> <span class="nf">displayResult</span><span class="p">()</span></div><div class='line' id='LC131'><br/></div><div class='line' id='LC132'>	<span class="c1">--define the 1st as the user, who should be in the ceneter and be in red color</span></div><div class='line' id='LC133'>	<span class="c1">-- which means that index of userinfo is 1,so</span></div><div class='line' id='LC134'><br/></div><div class='line' id='LC135'>	<span class="c1">--local id = userinfo[1][1]</span></div><div class='line' id='LC136'>	<span class="c1">--print(&quot; 1st user&#39;s id:&quot; ..id)</span></div><div class='line' id='LC137'><br/></div><div class='line' id='LC138'>	<span class="kd">local</span> <span class="n">defaultxpos</span> <span class="o">=</span> <span class="n">display</span><span class="p">.</span><span class="n">contentWidth</span> <span class="o">/</span> <span class="mi">2</span></div><div class='line' id='LC139'>	<span class="kd">local</span> <span class="n">defaultypos</span> <span class="o">=</span> <span class="n">display</span><span class="p">.</span><span class="n">contentHeight</span> <span class="o">/</span> <span class="mi">2</span></div><div class='line' id='LC140'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--local defaultxpos = 20</span></div><div class='line' id='LC141'>	 <span class="c1">--local defaultypos = 20</span></div><div class='line' id='LC142'><br/></div><div class='line' id='LC143'>	 <span class="c1">-- get the max display value on screen</span></div><div class='line' id='LC144'>	<span class="kd">local</span> <span class="n">displayLatitude</span> <span class="o">=</span> <span class="n">configinfo</span><span class="p">[</span><span class="mi">1</span><span class="p">]</span> <span class="o">*</span> <span class="mi">2</span></div><div class='line' id='LC145'>	<span class="kd">local</span> <span class="n">displayLongitude</span><span class="o">=</span> <span class="n">configinfo</span><span class="p">[</span><span class="mi">2</span><span class="p">]</span> <span class="o">*</span> <span class="mi">2</span></div><div class='line' id='LC146'><br/></div><div class='line' id='LC147'>	 <span class="c1">-- user relative physical coordinates on screen</span></div><div class='line' id='LC148'>	<span class="kd">local</span> <span class="n">userxpos</span><span class="p">,</span> <span class="n">userypos</span></div><div class='line' id='LC149'><br/></div><div class='line' id='LC150'>	<span class="c1">-- there is a overlapping issue here</span></div><div class='line' id='LC151'>	<span class="c1">--every time we have to remove the circle firstly when we begin to create it again</span></div><div class='line' id='LC152'><br/></div><div class='line' id='LC153'>	<span class="k">for</span> <span class="n">index</span><span class="p">,</span><span class="n">value</span> <span class="k">in</span> <span class="nb">ipairs</span><span class="p">(</span><span class="n">userinfo</span><span class="p">)</span> <span class="k">do</span></div><div class='line' id='LC154'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--print(&quot;index:&quot; .. index)</span></div><div class='line' id='LC155'><br/></div><div class='line' id='LC156'>		<span class="kd">local</span> <span class="n">id</span><span class="p">,</span><span class="n">name</span><span class="p">,</span><span class="n">latitude</span><span class="p">,</span><span class="n">longitude</span> <span class="o">=</span> <span class="n">userinfo</span><span class="p">[</span><span class="n">index</span><span class="p">][</span><span class="mi">1</span><span class="p">],</span><span class="n">userinfo</span><span class="p">[</span><span class="n">index</span><span class="p">][</span><span class="mi">2</span><span class="p">],</span><span class="n">userinfo</span><span class="p">[</span><span class="n">index</span><span class="p">][</span><span class="mi">3</span><span class="p">],</span><span class="n">userinfo</span><span class="p">[</span><span class="n">index</span><span class="p">][</span><span class="mi">4</span><span class="p">]</span></div><div class='line' id='LC157'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kd">local</span> <span class="n">relativeLatitude</span><span class="p">,</span><span class="n">relativeLongitude</span> <span class="o">=</span> <span class="n">userinfo</span><span class="p">[</span><span class="n">index</span><span class="p">][</span><span class="mi">5</span><span class="p">],</span><span class="n">userinfo</span><span class="p">[</span><span class="n">index</span><span class="p">][</span><span class="mi">6</span><span class="p">]</span></div><div class='line' id='LC158'><br/></div><div class='line' id='LC159'>		<span class="c1">--calculate the relative physical coordinates and map the physical coordinates to display coordinates (320 x 480)</span></div><div class='line' id='LC160'><br/></div><div class='line' id='LC161'>		<span class="c1">--print(&quot;relativeLatitude:&quot; ..relativeLatitude .. &quot;,relativeLongitude:&quot; ..relativeLongitude)</span></div><div class='line' id='LC162'>		<span class="k">if</span> <span class="n">relativeLatitude</span><span class="o">&gt;=</span><span class="mi">0</span> <span class="k">then</span></div><div class='line' id='LC163'><br/></div><div class='line' id='LC164'>			 <span class="n">userxpos</span> <span class="o">=</span> <span class="n">defaultxpos</span> <span class="o">+</span> <span class="p">(</span><span class="n">latitude</span> <span class="o">*</span> <span class="n">screenWidth</span><span class="p">)</span> <span class="o">/</span> <span class="n">displayLatitude</span></div><div class='line' id='LC165'><br/></div><div class='line' id='LC166'>		<span class="k">else</span></div><div class='line' id='LC167'>			 <span class="n">userxpos</span> <span class="o">=</span> <span class="n">defaultxpos</span> <span class="o">-</span> <span class="p">(</span><span class="nb">math.abs</span><span class="p">(</span><span class="n">latitude</span><span class="p">)</span> <span class="o">*</span> <span class="n">screenWidth</span><span class="p">)</span> <span class="o">/</span> <span class="n">displayLatitude</span></div><div class='line' id='LC168'><br/></div><div class='line' id='LC169'>		<span class="k">end</span></div><div class='line' id='LC170'><br/></div><div class='line' id='LC171'><br/></div><div class='line' id='LC172'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">relativeLongitude</span><span class="o">&gt;=</span><span class="mi">0</span> <span class="k">then</span></div><div class='line' id='LC173'>			<span class="n">userypos</span> <span class="o">=</span>  <span class="n">defaultypos</span> <span class="o">+</span> <span class="p">(</span><span class="n">longitude</span> <span class="o">*</span> <span class="n">screenHeight</span><span class="p">)</span> <span class="o">/</span> <span class="n">displayLongitude</span></div><div class='line' id='LC174'>		 <span class="k">else</span></div><div class='line' id='LC175'><br/></div><div class='line' id='LC176'>			<span class="n">userypos</span> <span class="o">=</span>  <span class="n">defaultypos</span> <span class="o">-</span> <span class="p">(</span><span class="nb">math.abs</span><span class="p">(</span><span class="n">longitude</span><span class="p">)</span> <span class="o">*</span> <span class="n">screenHeight</span><span class="p">)</span> <span class="o">/</span> <span class="n">displayLongitude</span></div><div class='line' id='LC177'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC178'><br/></div><div class='line' id='LC179'>		 <span class="nb">print</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">id:&quot;</span> <span class="o">..</span> <span class="n">id</span> <span class="o">..</span> <span class="s2">&quot;</span><span class="s">,userxpos:&quot;</span> <span class="o">..</span> <span class="n">userxpos</span> <span class="o">..</span> <span class="s2">&quot;</span><span class="s">,userypos:&quot;</span> <span class="o">..</span> <span class="n">userypos</span><span class="p">)</span></div><div class='line' id='LC180'><br/></div><div class='line' id='LC181'>		 <span class="c1">---- create a new circle</span></div><div class='line' id='LC182'><br/></div><div class='line' id='LC183'>		 <span class="n">circle</span> <span class="o">=</span> <span class="n">display</span><span class="p">.</span><span class="n">newCircle</span><span class="p">(</span><span class="n">userxpos</span><span class="p">,</span><span class="n">userypos</span><span class="p">,</span><span class="mi">15</span><span class="p">)</span></div><div class='line' id='LC184'><br/></div><div class='line' id='LC185'>		<span class="k">if</span> <span class="n">index</span> <span class="o">==</span> <span class="mi">1</span> <span class="k">then</span></div><div class='line' id='LC186'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">-- print(&quot;The user&#39;s id:&quot; .. id)</span></div><div class='line' id='LC187'><br/></div><div class='line' id='LC188'>	         <span class="n">circle</span><span class="p">:</span><span class="n">setFillColor</span><span class="p">(</span><span class="mi">255</span><span class="p">,</span><span class="mi">0</span><span class="p">,</span><span class="mi">0</span><span class="p">,</span><span class="mi">255</span><span class="p">)</span></div><div class='line' id='LC189'><br/></div><div class='line' id='LC190'>		<span class="k">else</span></div><div class='line' id='LC191'><br/></div><div class='line' id='LC192'>			<span class="c1">--print(&quot;The other users&#39; id:&quot; .. id)</span></div><div class='line' id='LC193'><br/></div><div class='line' id='LC194'>			<span class="n">circle</span><span class="p">:</span><span class="n">setFillColor</span><span class="p">(</span><span class="mi">0</span><span class="p">,</span><span class="mi">0</span><span class="p">,</span><span class="mi">255</span><span class="p">,</span><span class="mi">255</span><span class="p">)</span></div><div class='line' id='LC195'><br/></div><div class='line' id='LC196'>		<span class="k">end</span></div><div class='line' id='LC197'><br/></div><div class='line' id='LC198'>		<span class="n">circle</span><span class="p">.</span><span class="n">name</span> <span class="o">=</span> <span class="n">display</span><span class="p">.</span><span class="n">newText</span><span class="p">(</span><span class="n">name</span><span class="p">,</span><span class="n">userxpos</span><span class="p">,</span><span class="n">userypos</span><span class="p">,</span><span class="n">native</span><span class="p">.</span><span class="n">systemFont</span><span class="p">,</span><span class="mi">16</span><span class="p">)</span></div><div class='line' id='LC199'>		<span class="c1">--circle.name.isVisible = false</span></div><div class='line' id='LC200'><br/></div><div class='line' id='LC201'>	<span class="k">end</span></div><div class='line' id='LC202'><br/></div><div class='line' id='LC203'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">--if being tapped, the user name will be displayed</span></div><div class='line' id='LC204'><br/></div><div class='line' id='LC205'>	 <span class="n">addListener</span><span class="p">()</span></div><div class='line' id='LC206'><br/></div><div class='line' id='LC207'>	<span class="c1">-- display the text</span></div><div class='line' id='LC208'>	<span class="c1">--print(&quot;defaultxpos:&quot; ..defaultxpos .. &quot;,defaultypos:&quot; .. defaultypos)</span></div><div class='line' id='LC209'><br/></div><div class='line' id='LC210'>	<span class="kd">local</span> <span class="n">textxpos</span> <span class="o">=</span> <span class="n">defaultxpos</span> <span class="o">-</span> <span class="mi">250</span></div><div class='line' id='LC211'>	<span class="kd">local</span> <span class="n">textypos</span><span class="o">=</span> <span class="n">defaultypos</span> <span class="o">+</span> <span class="mi">270</span></div><div class='line' id='LC212'><br/></div><div class='line' id='LC213'>	<span class="kd">local</span> <span class="n">myText</span><span class="o">=</span><span class="n">display</span><span class="p">.</span><span class="n">newText</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">Successfully get data&quot;</span><span class="p">,</span><span class="n">defaultxpos</span><span class="p">,</span><span class="n">textypos</span><span class="p">,</span><span class="n">native</span><span class="p">.</span><span class="n">systemFont</span><span class="p">,</span><span class="mi">20</span><span class="p">)</span></div><div class='line' id='LC214'>	<span class="c1">--myText.x = display.contentWidth / 2</span></div><div class='line' id='LC215'>	<span class="c1">--myText.y = display.contentHeight / 16</span></div><div class='line' id='LC216'>	<span class="n">myText</span><span class="p">:</span><span class="n">setTextColor</span><span class="p">(</span><span class="mi">255</span><span class="p">,</span><span class="mi">255</span><span class="p">,</span><span class="mi">255</span><span class="p">)</span></div><div class='line' id='LC217'><br/></div><div class='line' id='LC218'><br/></div><div class='line' id='LC219'><span class="k">end</span></div><div class='line' id='LC220'><br/></div><div class='line' id='LC221'><br/></div><div class='line' id='LC222'><span class="k">function</span> <span class="nf">listener</span><span class="p">(</span><span class="n">event</span><span class="p">)</span></div><div class='line' id='LC223'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">network</span><span class="p">.</span><span class="n">download</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">http://www.cse.cuhk.edu.hk/~tklam/pos.txt&quot;</span><span class="p">,</span><span class="s2">&quot;</span><span class="s">GET&quot;</span><span class="p">,</span><span class="n">networkListener</span><span class="p">,</span><span class="s2">&quot;</span><span class="s">pos.txt&quot;</span><span class="p">,</span><span class="n">system</span><span class="p">.</span><span class="n">DocumentsDirectory</span><span class="p">)</span></div><div class='line' id='LC224'><span class="k">end</span></div><div class='line' id='LC225'><br/></div><div class='line' id='LC226'><span class="k">function</span> <span class="nf">networkListener</span><span class="p">(</span><span class="n">event</span><span class="p">)</span></div><div class='line' id='LC227'>	<span class="k">if</span> <span class="p">(</span><span class="n">event</span><span class="p">.</span><span class="n">isError</span><span class="p">)</span> <span class="k">then</span></div><div class='line' id='LC228'><br/></div><div class='line' id='LC229'>	    <span class="nb">print</span><span class="p">(</span><span class="s2">&quot;</span><span class="s">Network error - download failed&quot;</span> <span class="o">..</span> <span class="n">event</span><span class="p">.</span><span class="n">response</span><span class="p">)</span></div><div class='line' id='LC230'><br/></div><div class='line' id='LC231'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span></div><div class='line' id='LC232'>	<span class="k">else</span></div><div class='line' id='LC233'><br/></div><div class='line' id='LC234'>	 <span class="c1">-- construct the related user data</span></div><div class='line' id='LC235'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">constructData</span><span class="p">();</span></div><div class='line' id='LC236'><br/></div><div class='line' id='LC237'>	 <span class="c1">-- display the result on screen and interact with the user</span></div><div class='line' id='LC238'>	 <span class="n">displayResult</span><span class="p">()</span></div><div class='line' id='LC239'><br/></div><div class='line' id='LC240'>	 <span class="k">end</span></div><div class='line' id='LC241'><span class="k">end</span></div><div class='line' id='LC242'><span class="c1">------ main ------</span></div><div class='line' id='LC243'><br/></div><div class='line' id='LC244'><span class="c1">-- variable</span></div><div class='line' id='LC245'><span class="c1">---- table userinfo is used to store the user&#39;s information like id, name,RelativeLongitude, RelativeLatitude,longitude,latitude</span></div><div class='line' id='LC246'><span class="n">userinfo</span> <span class="o">=</span> <span class="p">{}</span></div><div class='line' id='LC247'><br/></div><div class='line' id='LC248'><span class="c1">---- table configinfo is used to store the current display information like screen resolution, Max Latitude , Max Longitude</span></div><div class='line' id='LC249'><span class="n">configinfo</span> <span class="o">=</span> <span class="p">{}</span></div><div class='line' id='LC250'><br/></div><div class='line' id='LC251'><span class="c1">---- the screen resolution</span></div><div class='line' id='LC252'><span class="c1">---- It is better to define a configuration file</span></div><div class='line' id='LC253'><span class="n">screenWidth</span><span class="p">,</span><span class="n">screenHeight</span> <span class="o">=</span><span class="mi">320</span><span class="p">,</span><span class="mi">480</span></div><div class='line' id='LC254'><br/></div><div class='line' id='LC255'><span class="c1">--get data every 10 seconds</span></div><div class='line' id='LC256'><span class="n">timer</span><span class="p">.</span><span class="n">performWithDelay</span><span class="p">(</span><span class="mi">10000</span><span class="p">,</span><span class="n">listener</span><span class="p">,</span><span class="mi">0</span><span class="p">)</span></div><div class='line' id='LC257'><br/></div><div class='line' id='LC258'><span class="c1">--networkListener()</span></div><div class='line' id='LC259'><span class="c1">--userinfo[1] = { 1, &quot;s11222&quot;, 10, 10}</span></div></pre></div>
            </td>
          </tr>
        </table>
  </div>

  </div>
</div>

<a href="#jump-to-line" rel="facebox[.linejump]" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
<div id="jump-to-line" style="display:none">
  <form accept-charset="UTF-8" class="js-jump-to-line-form">
    <input class="linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" autofocus>
    <button type="submit" class="button">Go</button>
  </form>
</div>

        </div>

      </div><!-- /.repo-container -->
      <div class="modal-backdrop"></div>
    </div><!-- /.container -->
  </div><!-- /.site -->


    </div><!-- /.wrapper -->

      <div class="container">
  <div class="site-footer">
    <ul class="site-footer-links right">
      <li><a href="https://status.github.com/">Status</a></li>
      <li><a href="http://developer.github.com">API</a></li>
      <li><a href="http://training.github.com">Training</a></li>
      <li><a href="http://shop.github.com">Shop</a></li>
      <li><a href="/blog">Blog</a></li>
      <li><a href="/about">About</a></li>

    </ul>

    <a href="/">
      <span class="mega-octicon octicon-mark-github"></span>
    </a>

    <ul class="site-footer-links">
      <li>&copy; 2013 <span title="0.14949s from fe13.rs.github.com">GitHub</span>, Inc.</li>
        <li><a href="/site/terms">Terms</a></li>
        <li><a href="/site/privacy">Privacy</a></li>
        <li><a href="/security">Security</a></li>
        <li><a href="/contact">Contact</a></li>
    </ul>
  </div><!-- /.site-footer -->
</div><!-- /.container -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
          <div class="suggester-container">
              <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                 data-url="/muyun/dev.mycode/suggestions/commit">
              </div>
          </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped leftwards" title="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped leftwards"
      title="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="octicon octicon-alert"></span>
      <a href="#" class="octicon octicon-remove-close close ajax-error-dismiss"></a>
      Something went wrong with that request. Please try again.
    </div>

    
  </body>
</html>

