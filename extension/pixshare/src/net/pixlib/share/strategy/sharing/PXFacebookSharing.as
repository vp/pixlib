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

	import net.pixlib.structures.PXDimension;
	import net.pixlib.share.PXSharingOptions;

	import flash.net.URLVariables;
	
	/**
	 * Shares informations on Facebook platform.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var post : PXPostSharing = new PXPostSharing();
	 * post.platform = new PXFacebookSharing();
	 * post.share("Incredible site here", "http://blog.pixlib.net");
	 * </listing>
	 * 
	 * @see net.pixlib.share.PXPostSharing
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXFacebookSharing extends PXAbstractSharingStrategy
	{
		/**
		 * Facebook service adress.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var SERVICE_URL : String = "http://www.facebook.com/sharer.php";
		
		/**
		 * Facebook form size.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var FORM_SIZE : PXDimension = new PXDimension(500, 400);
		
		/**
		 * Creates new instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXFacebookSharing()
		{
			service = SERVICE_URL;
			formSize = FORM_SIZE;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buildVariables(text : String, url : String, options : PXSharingOptions = null) : void
		{
			apiVariables = new URLVariables();
			apiVariables.u = url;
			apiVariables.t = text;
		}
	}
}
