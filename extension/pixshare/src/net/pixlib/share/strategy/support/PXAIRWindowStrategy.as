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

	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.events.Event;
	import flash.html.HTMLLoader;


	/**
	 * The PXAIRWindowStrategy class use an AIR Window to display 
	 * platform sharing system.
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
	public class PXAIRWindowStrategy implements PXSupportStrategy
	{
		/**
		 * @private
		 */
		private var _html : HTMLLoader;
		
		/**
		 * @private
		 */
		private var _win : NativeWindow;
		
		/**
		 * @inheritDoc
		 */
		public function send(sharing : PXSharingStrategy) : void
		{
			var options : NativeWindowInitOptions = new NativeWindowInitOptions();
			options.resizable = false;
			options.maximizable = false;
			options.minimizable = false;

			_html = HTMLLoader.createRootWindow(true, options, true);
			
			_win = _html.stage.nativeWindow;
			_win.width = sharing.formSize.width;
			_win.height = sharing.formSize.height;
			_win.addEventListener(Event.CLOSE, _onClose);
			_win.alwaysInFront = true;

			_html.load(sharing.request);
			_html.addEventListener(Event.COMPLETE, _onLoad);
		}
		
		/**
		 * @private
		 */
		private function _onClose(event : Event) : void
		{
			_win.removeEventListener(Event.CLOSE, _onClose);
			_win = null;
			_html = null;
		}
		
		/**
		 * @private
		 */
		private function _onLoad(event : Event) : void
		{
			_win.activate();
			_html.removeEventListener(Event.COMPLETE, _onLoad);
		}
	}
}
