/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.share
{
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.share.strategy.support.PXPopupStrategy;
	import flash.net.navigateToURL;

	/**
	 * The PXPostSharing class allow to share informations using social networks 
	 * or direct emailing for example.
	 * 
	 * <p>You customize which strategy to use to share informations (Facebook, 
	 * Twitter, Google Buzz,... and strategy to use to send this sharing request (browser 
	 * popup, AIR window,...). <br/>
	 * Default use a browser popup strategy.</p>
	 * 
	 * @example
	 * <listing>
	 * 
	 * var post : PXPostSharing = new PXPostSharing();
	 * post.platform = new PXFacebookSharing();
	 * post.share("Incredible site here", "http://blog.pixlib.net");
	 * </listing>
	 * 
	 * @example
	 * <listing>
	 * 
	 * var post : PXPostSharing = new PXPostSharing();
	 * post.platform = new PXTwitterSharing();
	 * post.support = new PXAIRWindowStrategy();
	 * post.share("Incredible site here", "http://blog.pixlib.net");
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXPostSharing
	{
		/**
		 * The Sharing strategy to use for building correct request.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var platform : PXSharingStrategy;
		
		/**
		 * The strategy to use to open sharing platform system.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var support : PXSupportStrategy;
		
		/**
		 * Creates new instance.
		 * 
		 * @param shareStrategy 	(optional) Sharing strategy to use
		 * @param supportStrategy	(optional) Support strategy to use. 
		 * 							If <code>null</code> use a PXPopupStrategy 
		 * 							strategy. 
		 * 							
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXPostSharing(shareStrategy : PXSharingStrategy = null, supportStrategy : PXSupportStrategy = null)
		{
			if (shareStrategy) platform = shareStrategy;
			support = (supportStrategy) ? supportStrategy : new PXPopupStrategy();
		}
		
		/**
		 * Shares passed-in informations.
		 * 
		 * @param text 		Shared text
		 * @param url		Shared content url
		 * @param options	(optional) More sharing options
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function share(text : String, url : String, options : PXSharingOptions = null) : void
		{
			if (platform)
			{
				platform.share(text, url, options);

				if (platform.useOpenStrategy)
				{
					if (support)
					{
						support.send(platform);
						platform.clear();
					}
					else
					{
						throw new PXNullPointerException("Sending strategy is null !", this);
					}
				}
				else
				{
					navigateToURL(platform.request, "_blank");
				}
			}
			else throw new PXNullPointerException("Sharing strategy is null !", this);
		}
	}
}
