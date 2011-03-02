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
package net.pixlib.share.strategy.support
{
	import net.pixlib.share.PXSupportStrategy;
	import net.pixlib.share.PXSharingStrategy;

	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;


	/**
	 * The PXPopupStrategy class open a browser popup to display 
	 * platform sharing system.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var post : PXPostSharing = new PXPostSharing();
	 * post.platform = new PXFacebookSharing();
	 * post.share("Incredible site here", "http://blog.pixlib.net");
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXPopupStrategy implements PXSupportStrategy
	{
		/**
		 * @inheritDoc
		 */
		public function send(sharing : PXSharingStrategy) : void
		{
			if (!_open(sharing.request.url + "?" + sharing.variables.toString(), "_blank", "width=" + sharing.formSize.width + ", height=" + sharing.formSize.height + "toolbar=0, status=0"))
			{
				navigateToURL(sharing.request, "_blank");
			}
		}
		
		/**
		 * @private
		 */
		private static function _open(url : String, name : String = "_blank", features : String = "") : Boolean
		{
			if (ExternalInterface.available)
			{
				try
				{
					return ExternalInterface.call("function openShare(url, name, features) { return window.open(url, name, features) != null; }", url, name, features);
				}
				catch (e : Error)
				{

				}
			}
			return false;
		}
	}
}
