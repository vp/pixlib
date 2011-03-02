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
package net.pixlib.share.strategy.sharing
{

	import net.pixlib.share.PXSharingOptions;
	import net.pixlib.structures.PXDimension;

	import flash.net.URLVariables;


	/**
	 * Shares informations by Email.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var post : PXPostSharing = new PXPostSharing();
	 * post.platform = new PXEmailSharing();
	 * post.share("Incredible site here", "rom&#64;anothserv.com");
	 * </listing>
	 * 
	 * @example
	 * <listing>
	 * 
	 * var opt : PXSharingOptions = new PXSharingOptions();
	 * opt.message = "This is the email body";
	 * 
	 * var post : PXPostSharing = new PXPostSharing();
	 * post.platform = new PXEmailSharing();
	 * post.share("Incredible site here", "rom&#64;anothserv.com", opt);
	 * </listing>
	 * 
	 * @see net.pixlib.share.PXPostSharing
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXEmailSharing extends PXAbstractSharingStrategy
	{
		/**
		 * @inheritDoc
		 */
		override public function get useOpenStrategy() : Boolean
		{
			return false;	
		}
		
		/**
		 * Creates new instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXEmailSharing()
		{
			service = "";
			formSize = new PXDimension(0, 0);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buildVariables(text : String, url : String, options : PXSharingOptions = null) : void
		{
			service = "mailto:" + url;
			
			apiVariables = new URLVariables();
			apiVariables.subject = text;
			if(options && options.message) apiVariables.body = options.message;
		}
	}
}
