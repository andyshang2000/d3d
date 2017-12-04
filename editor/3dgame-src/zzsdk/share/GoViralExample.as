package zzsdk.share
{
	import com.milkmangames.nativeextensions.GVFacebookAppEvent;
	import com.milkmangames.nativeextensions.GVFacebookFriend;
	import com.milkmangames.nativeextensions.GVHttpMethod;
	import com.milkmangames.nativeextensions.GoViral;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.milkmangames.nativeextensions.events.GVMailEvent;
	import com.milkmangames.nativeextensions.events.GVShareEvent;
	import com.milkmangames.nativeextensions.events.GVTwitterEvent;

	import flash.display.BitmapData;

	import so.cuo.platform.common.CommonANE;

	/** GoViralExample App */
	public class GoViralExample
	{
		//
		// Definitions
		//
		private static var _instance:GoViralExample;
		/** CHANGE THIS TO YOUR FACEBOOK APP ID! */
		public static const FACEBOOK_APP_ID:String = "1430208220546304";
		private var shareMessage:String;

		public static function getInstance():GoViralExample
		{
			if (_instance == null)
			{
				_instance = new (GoViralExample)();
			}

			return (_instance);
		}
		/** Post a photo to the facebook stream */
		private var _currentBitmapdata:BitmapData
		private var _callBackFun:Function

		public function postPhotoFacebook(msg:String, bitmap:BitmapData, callBack:Function):void
		{
			this._callBackFun = callBack;

			if (!checkLoggedInFacebook())
			{
				loginFacebook(bitmap)
				_currentBitmapdata = bitmap.clone();
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN, onFacebookEvent);
				return;
			}
			else
			{
				log("post facebook pic...");
				//var asBitmap:Bitmap=new testImageClass() as Bitmap;
				GoViral.goViral.facebookPostPhoto(shareMessage = msg, bitmap);
				log("posted fb pic.");
			}
		}

		/** Login to facebook */
		public function loginFacebook(bitmap:BitmapData):void
		{
			log("Login facebook...");
			if (!GoViral.goViral.isFacebookAuthenticated())
			{
				// you must set at least one read permission.  if you don't know what to pick, 'basic_info' is fine.
				// PUBLISH PERMISSIONS are NOT permitted by Facebook here anymore.
				GoViral.goViral.authenticateWithFacebook("public_profile");
					//GoViral.goViral.authenticateWithFacebook(); 
			}
			else
			{
				postPhotoFacebook(shareMessage, bitmap, this._callBackFun)
				log("done.");
			}

		}

		/** Init */
		public function init():void
		{
			log("Started GoViral Example.");
			// check if GoViral is supported.  note that this just determines platform support- iOS - and not
			// whether the particular version supports it.		
			if (!GoViral.isSupported())
			{
				log("Extension is not supported on this platform.");
				return;
			}
			log("will create.");
			GoViral.create();
			log("Extension Initialized.");

			// initialize facebook.		
			// this is to make sure you remembered to put in your app ID !
			if (FACEBOOK_APP_ID == "YOUR_FACEBOOK_APP_ID")
			{
				log("You forgot to put in Facebook ID!");
			}
			else
			{
				log("Init facebook...");
				// as of April 2013, Facebook is dropping support for iOS devices with a version below 5.
				// You can check this with isFacebookSupported():
				if (GoViral.goViral.isFacebookSupported())
				{
					log("facebook support on device");
					try
					{
						GoViral.goViral.initFacebook(FACEBOOK_APP_ID, "");
					}
					catch (err:Error)
					{
						log(err.getStackTrace());
					}
					log("iniialized.");
				}
				else
				{
					log("Warning: Facebook not supported on this device.");
				}

			}

			// set up all the event listeners.
			// you only need the ones for the services you want to use.		

			// mail events
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_CANCELED, onMailEvent);
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_FAILED, onMailEvent);
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_SAVED, onMailEvent);
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_SENT, onMailEvent);

			// facebook events
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_CANCELED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FAILED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FINISHED, onFacebookEvent);
			//GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_FAILED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_AD_ID_RESPONSE, onFacebookEvent);

			// twitter events
			GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_CANCELED, onTwitterEvent);
			GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_FAILED, onTwitterEvent);
			GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_FINISHED, onTwitterEvent);

			// Generic sharing events
			GoViral.goViral.addEventListener(GVShareEvent.GENERIC_MESSAGE_SHARED, onShareEvent);
			GoViral.goViral.addEventListener(GVShareEvent.SOCIAL_COMPOSER_CANCELED, onShareEvent);
			GoViral.goViral.addEventListener(GVShareEvent.SOCIAL_COMPOSER_FINISHED, onShareEvent);
		}

		// facebook

		/** Logout of facebook */
		public function logoutFacebook():void
		{
			log("logout fb.");
			GoViral.goViral.logoutFacebook();
			log("done logout.");
		}

		/** Post to the facebook wall / feed via dialog */
		public function postFeedFacebook():void
		{
			if (!checkLoggedInFacebook())
				return;

			log("posting fb feed...");
			GoViral.goViral.showFacebookFeedDialog("Posting from AIR", "This is a caption", "This is a message!", "This is a description", "http://www.milkmangames.com", "http://www.milkmangames.com/blog/wp-content/uploads/2012/01/v202.jpg");

			log("done feed post.");
		}

		/** Get a list of all your facebook friends */
		public function getFriendsFacebook():void
		{
			if (!checkLoggedInFacebook())
				return;

			log("getting friends.(finstn)..");
			GoViral.goViral.requestFacebookFriends({fields: "installed,first_name"});
			log("sent friend list request.");
		}

		/** Get your own facebook profile */
		public function getMeFacebook():void
		{
			if (!checkLoggedInFacebook())
				return;

			log("Getting profile...");
			GoViral.goViral.requestMyFacebookProfile();
			log("sent profile request.");
		}

		/** Get Facebook Access Token */
		public function getFacebookToken():void
		{
			log("Retrieving access token...");
			var accessToken:String = GoViral.goViral.getFbAccessToken();
			var accessExpiry:Number = GoViral.goViral.getFbAccessExpiry();
			log("expiry:" + accessExpiry + ",Token is:" + accessToken);
		}

		/** Make a post graph request */
		public function postGraphFacebook():void
		{
			if (!checkLoggedInFacebook())
				return;

			log("Graph posting...");
			var params:Object = {};
			params.name = "Name Test";
			params.caption = "Caption Test";
			params.link = "http://www.google.com";
			params.picture = "http://www.milkmangames.com/blog/wp-content/uploads/2012/01/v202.jpg";
			params.actions = new Array();
			params.actions.push({name: "Link NOW!", link: "http://www.google.com"});

			// notice the "publish_actions", a required publish permission to write to the graph!
			GoViral.goViral.facebookGraphRequest("me/feed", GVHttpMethod.POST, params, "publish_actions");
			log("post complete.");
		}

		/** Show a facebook friend invite dialog */
		public function inviteFriendsFacebook():void
		{
			if (!checkLoggedInFacebook())
				return;

			log("inviting friends.");
			GoViral.goViral.showFacebookRequestDialog("This is just a test", "My Title", "somedata");
			log("sent friend invite.");
		}

		/** Check you're logged in to facebook before doing anything else. */
		private function checkLoggedInFacebook():Boolean
		{
			// make sure you're logged in first
			if (!GoViral.goViral.isFacebookAuthenticated())
			{
				log("Not logged in!");
				return false;
			}
			return true;
		}

		/** Show a Facebook page by ID (request like) */
		private function likePageFacebook():void
		{
			log("Sending to Page...");
			// the page ID can be determined from the page URL;
			// for instance Milkman Games' Facebook page URL is 
			// https://www.facebook.com/pages/Milkman-Games-LLC/215322531827565,
			// so the ID is 215322531827565.
			GoViral.goViral.presentFacebookPageOrProfile("215322531827565");
			log("Sent to FB Page.");
		}

		//
		// Facebook Games Tracking Features
		//

		/** Submit a new high score to Facebook */
		private function submitFacebookScore():void
		{
			// make sure you're logged in first!
			if (!checkLoggedInFacebook())
				return;

			log("Sending facebook high score...");
			GoViral.goViral.postFacebookHighScore(2000);
			log("Waiting for high score response...");
		}

		/** Submit a new achievement to Facebook */
		private function submitFacebookAchievement():void
		{
			// make sure you're logged in first!
			if (!checkLoggedInFacebook())
				return;

			// for this to work, you need to create the achievement HTML on your own website and register it
			// with facebook, refer to https://developers.facebook.com/docs/games/achievements 
			log("Sending facebook achievement...");
			GoViral.goViral.postFacebookAchievement("http://www.friendsmash.com/opengraph/achievement_50.html");
			log("Waiting for achievement response...");
		}

		//
		// Facebook Ad Tracking Features
		//

		/** Log Facebook Ad Events */
		private function logFacebookEvents():void
		{
			// example of logging a level achieved event
			var levelAppEvent:GVFacebookAppEvent = new GVFacebookAppEvent(GVFacebookAppEvent.EVENT_NAME_ACHIEVED_LEVEL);
			levelAppEvent.setParameter(GVFacebookAppEvent.EVENT_PARAM_LEVEL, "32");
			log("Sending example level achieved app event...");
			GoViral.goViral.logFacebookAppEvent(levelAppEvent);

			// example of logging a spent credits event
			var creditsEvent:GVFacebookAppEvent = new GVFacebookAppEvent(GVFacebookAppEvent.EVENT_NAME_SPENT_CREDITS);
			creditsEvent.setValueToSum(15);
			creditsEvent.setParameter(GVFacebookAppEvent.EVENT_PARAM_CONTENT_TYPE, "music");
			creditsEvent.setParameter(GVFacebookAppEvent.EVENT_PARAM_CONTENT_ID, "somesong");
			log("Sending example spend credits app event...");
			GoViral.goViral.logFacebookAppEvent(creditsEvent);

			// example of sending a custom event
			var customEvent:GVFacebookAppEvent = new GVFacebookAppEvent("customEventName");
			log("Sending example custom app event...");
			GoViral.goViral.logFacebookAppEvent(customEvent);

			log("Sent 3 test app events.");
		}

		/** Request a facebook custom audience advertising ID */
		private function requestFacebookAdId():void
		{
			log("Requesting custom fb ad id...");
			GoViral.goViral.requestFacebookMobileAdID();
			log("Waiting for fb ad id response...");
		}

		//
		// Email
		//

		/** Send Test Email */
		public function sendTestEmail():void
		{
			if (GoViral.goViral.isEmailAvailable())
			{
				log("Opening email composer...");
				GoViral.goViral.showEmailComposer("This is a subject!", "who@where.com,john@doe.com", "This is the body of the message.", false);
				log("Composer opened.");
			}
			else
			{
				log("Email is not set up on this device.");
			}
		}

		/** Send Email with attached image */
		public function sendImageEmail():void
		{
		/*
		var asBitmap:Bitmap=new testImageClass() as Bitmap;
		log("Email composer w/image...");
		if (GoViral.goViral.isEmailAvailable())
		{
			GoViral.goViral.showEmailComposerWithBitmap("This has an attachment!","john@doe.com","I think youll like my pic",false,asBitmap.bitmapData);
		}
		else
		{
			log("Email is not available on this device.");
			return;
		}
		log("Mail composer opened.");
		*/
		}

		//
		// Android Generic Sharing
		//

		/** Send Generic Message */
		public function sendGenericMessage():void
		{
			if (!GoViral.goViral.isGenericShareAvailable())
			{
				log("Generic share doesn't work on this platform.");
				return;
			}

			log("Sending generic share intent...");
			GoViral.goViral.shareGenericMessage("The Subject", "The message!", false);
			log("done send share intent.");
		}

		/** Send Generic Message */
		public function sendGenericMessageWithImage():void
		{
		/*
		if (!GoViral.goViral.isGenericShareAvailable())
		{
			log("Generic share doesn't work on this platform.");
			return;
		}

		log("Sending generic share img intent...");
		var asBitmap:Bitmap=new testImageClass() as Bitmap;
		GoViral.goViral.shareGenericMessageWithImage("The Subject","The message!",false,asBitmap.bitmapData);
		log("done send share img intent.");
		*/
		}

		/** iOS 6 only sharing */
		public function shareSocialComposer():void
		{
		/*
		// note that SINA_WEIBO and TWITTER are also available...
		if (GoViral.goViral.isSocialServiceAvailable(GVSocialServiceType.FACEBOOK))
		{
			log("launch ios 6 social composer...");
			var asBitmap:Bitmap=new testImageClass() as Bitmap;
			GoViral.goViral.displaySocialComposerView(GVSocialServiceType.FACEBOOK,"Social Composer message",asBitmap.bitmapData,"http://www.milkmangames.com");
		}
		else
		{
			log("social composer service not available on device.");
		}
		*/
		}

		//
		// twitter
		//

		/** Post a status message to Twitter */
		public function postTwitter():void
		{
			log("posting to twitter.");

			// You should check GoViral.goViral.isTweetSheetAvailable() to determine
			// if you're able to use the built-in iOS Twitter UI.  If the phone supports it
			// (because its running iOS 5.0+, or an Android device with Twitter) it will return true and you can call
			// 'showTweetSheet'. 

			if (GoViral.goViral.isTweetSheetAvailable())
			{
				GoViral.goViral.showTweetSheet("This is a native twitter post!");
			}
			else
			{
				log("Twitter not available on this device.");
				return;
			}
		}

		/** Post a picture to twitter */
		public function postTwitterPic():void
		{
			log("post twitter pic.");

			// You should check GoViral.goViral.isTweetSheetAvailable() to determine
			// if you're able to use the built-in iOS Twitter UI.  If the phone supports it
			// (because its running iOS 5.0+, or an Android device with Twitter) it will return true and you can call
			// 'showTweetSheetWithImage'.

		/*
		if (GoViral.goViral.isTweetSheetAvailable())
		{
			var asBitmap:Bitmap=new testImageClass() as Bitmap;
			GoViral.goViral.showTweetSheetWithImage("This is a twitter post with a pic!",asBitmap.bitmapData);
		}
		else
		{
			log("Twitter not available on this device.");
			return;
		}
		log("done show tweet.");
		*/
		}

		//
		// Events
		//

		/** Handle Facebook Event */

		private function onFacebookEvent(e:GVFacebookEvent):void
		{
			switch (e.type)
			{
				case GVFacebookEvent.FB_DIALOG_CANCELED:
					log("Facebook dialog '" + e.dialogType + "' canceled.");
					break;
				case GVFacebookEvent.FB_DIALOG_FAILED:
					log("dialog err:" + e.errorMessage);
					break;
				case GVFacebookEvent.FB_DIALOG_FINISHED:
					log("fin dialog '" + e.dialogType + "'=" + e.jsonData);
					break;
				case GVFacebookEvent.FB_LOGGED_IN:
					//如果登陆成功直接发送
					postPhotoFacebook(shareMessage, this._currentBitmapdata, this._callBackFun)
					log("Logged in to facebook!");
					break;
				case GVFacebookEvent.FB_LOGGED_OUT:
					log("Logged out of facebook.");
					break;
				case GVFacebookEvent.FB_LOGIN_CANCELED:
					log("Canceled facebook login.");
					break;
				case GVFacebookEvent.FB_LOGIN_FAILED:
					if (this._callBackFun as Function)
					{
						this._callBackFun();
					}
					log("Login failed:" + e.errorMessage + "(notify? " + e.shouldNotifyFacebookUser + " " + e.facebookUserErrorMessage + ")");
					break;
				case GVFacebookEvent.FB_REQUEST_FAILED:
					if (this._callBackFun as Function)
					{
						this._callBackFun();
					}
					log("Facebook '" + e.graphPath + "' failed:" + e.errorMessage);
					break;
				case GVFacebookEvent.FB_REQUEST_RESPONSE:
					if (this._callBackFun as Function)
					{
						this._callBackFun();
					}
					// handle a friend list- there will be only 1 item in it if 
					// this was a 'my profile' request.				
					if (e.friends != null)
					{
						// 'me' was a request for own profile.
						if (e.graphPath == "me")
						{
							var myProfile:GVFacebookFriend = e.friends[0];
							log("Me: name='" + myProfile.name + "',gender='" + myProfile.gender + "',location='" + myProfile.locationName + "',bio='" + myProfile.bio + "'");
							return;
						}

						// 'me/friends' was a friends request.
						if (e.graphPath == "me/friends")
						{
							var allFriends:String = "";
							for each (var friend:GVFacebookFriend in e.friends)
							{
								allFriends += "," + friend.name;
							}

							log(e.graphPath + "= (" + e.friends.length + ")=" + allFriends + ",json=" + e.jsonData);
						}
						else
						{
							CommonANE.getInstance().alert("Thank You!", "Share Successfully", "OK");
							log(e.graphPath + " res=" + e.jsonData);
						}
					}
					else
					{
						log(e.graphPath + " res=" + e.jsonData);
					}
					break;
				case GVFacebookEvent.FB_AD_ID_RESPONSE:
					if (this._callBackFun as Function)
					{
						this._callBackFun();
					}
					log("Facebook Ad ID Response:" + e.facebookMobileAdId);
					break;
			}
		}

		/** Handle Twitter Event */
		private function onTwitterEvent(e:GVTwitterEvent):void
		{
			switch (e.type)
			{
				case GVTwitterEvent.TW_DIALOG_CANCELED:
					log("Twitter canceled.");
					break;
				case GVTwitterEvent.TW_DIALOG_FAILED:
					log("Twitter failed: " + e.errorMessage);
					break;
				case GVTwitterEvent.TW_DIALOG_FINISHED:
					log("Twitter finished.");
					break;
			}
		}

		/** Handle Mail Event */
		private function onMailEvent(e:GVMailEvent):void
		{
			switch (e.type)
			{
				case GVMailEvent.MAIL_CANCELED:
					log("Mail canceled.");
					break;
				case GVMailEvent.MAIL_FAILED:
					log("Mail failed:" + e.errorMessage);
					break;
				case GVMailEvent.MAIL_SAVED:
					log("Mail saved.");
					break;
				case GVMailEvent.MAIL_SENT:
					log("Mail sent!");
					break;
			}
		}

		/** Handle Generic Share Event */
		private function onShareEvent(e:GVShareEvent):void
		{
			log("share finished.");
		}

		//
		// Impelementation
		//
		/** Log */
		private function log(msg:String):void
		{
			trace("[GoViralExample] " + msg);
		}
	}
}
