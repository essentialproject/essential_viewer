<%--
 Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--%>
<!-- Do not remove the following comment line - Essential Form Login interface -->
<!-- Essential Publishing Error Page -->
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link rel="stylesheet" href="css/bootstrap.min.css" type="text/css"/>
		<link rel="stylesheet" href="js/context-menu/jquery.contextMenu.min.css" type="text/css"/>
		<link rel="stylesheet" href="css/font-awesome.min.css" type="text/css"/>
		<link rel="stylesheet" href="css/essential-core.css" type="text/css"/>
		<link href="fonts/source-sans/source-sans-pro.css" rel="stylesheet" type="text/css"/>
		<link rel="stylesheet" href="user/custom.css" type="text/css"/>
		<style type="text/css">
		.form-signin {
		  max-width: 330px;
		}
		.form-signin .form-signin-heading,
		.form-signin .checkbox {
		  margin-bottom: 10px;
		}
		.form-signin .checkbox {
		  font-weight: normal;
		}
		.form-signin .form-control {
		  position: relative;
		  height: auto;
		  -webkit-box-sizing: border-box;
		     -moz-box-sizing: border-box;
		          box-sizing: border-box;
		  padding: 5px;
		  font-size: 14px;
		  margin-bottom: 10px;
		}
		.form-signin .form-control:focus {
		  z-index: 2;
		}
		.form-signin input[type="email"] {
		  margin-bottom: -1px;
		  border-bottom-right-radius: 0;
		  border-bottom-left-radius: 0;
		}
		.form-signin input[type="password"] {
		  margin-bottom: 10px;
		  border-top-left-radius: 0;
		  border-top-right-radius: 0;
		}
		</style>
		<title>Login</title>
	</head>
	<body>
		<nav class="app-brand-header">
			<div class="app-logo pull-left">
				<img src="images/ev5_essential_project_header_white.png" alt="application logo" style="margin-top:3px;"/>
			</div>
			<div class="pull-right text-white small" style="margin-top:3px;">
				<a class="header-link" href="http://www.enterprise-architecture.org/about/licensing">Licensing</a>
				<span> | </span>
				<a class="header-link" href="http://www.enterprise-architecture.org/services">Support</a>
				<span> | </span>
				<a class="header-link" href="http://www.enterprise-architecture.org/forums">Community</a>
			</div>
		</nav>
		<nav class="navbar navbar-default nav-color">
			<div class="container-fluid">
				<!-- Brand and toggle get grouped for better mobile display -->
				<div class="navbar-header">
					<a class="navbar-brand">
						<div class="tenant-logo">
							<img alt="tenant logo" src="images/eas_logo_2014_white.png">
							</img>
						</div>
					</a>
				</div>
			</div>
			<!-- /.container-fluid -->
		</nav>
		<div class="container-fluid ">
			<div class="verticalSpacer_10px"></div>
			 <div class="row">
			 	<div class="col-xs-12">
			 		<h2>Error</h2>
                    <p>Invalid username and/or password.</p>
                    <p><a href='<%= response.encodeURL("report") %>'>Click here to try again</a>.</p>
			 	</div>
			 </div>	
		</div>
		<footer>
			<div class="col-xs-12 text-center bg-black text-white">
				<span class="pageFooterLabel">Powered by <strong><a class="text-white" href="http://www.enterprise-architecture.org">The Essential Project</a></strong>, the free, open-source Enterprise Architecture Management Platform.</span>
			</div>
		</footer>
	</body>
</html>

