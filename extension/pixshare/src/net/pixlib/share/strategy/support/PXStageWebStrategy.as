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
	import net.pixlib.core.PXApplication;
	import net.pixlib.share.PXSupportStrategy;
	import net.pixlib.share.PXSharingStrategy;

	import flash.display.DisplayObject;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;


	/**
	 * The PXStageWebStrategy class use new StageWebView feature of 
	 * Adobe Flash Player 10.2 to open sharing ssytem.
	 * 
	 * <p>This features is not currently implemented.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXStageWebStrategy implements PXSupportStrategy
	{
		/**
		 * @private
		 */
		private var _view : StageWebView;
		
		/**
		 * @inheritDoc
		 */
		public function send(sharing : PXSharingStrategy) : void
		{
			var container : DisplayObject = PXApplication.getInstance().root;
			
			_view = new StageWebView();
			_view.stage = container.stage;
			_view.viewPort = new Rectangle(0, 0, container.stage.stageWidth, container.stage.stageHeight);
			_view.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChanging);
            _view.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChange);
			_view.loadURL(sharing.request.url + "?" + sharing.variables.toString());
		}
		
		/**
		 * @private
		 */
		private function onLocationChange(event : LocationChangeEvent) : void
		{
			trace(event.location);
		}
		
		/**
		 * @private
		 */
		private function onLocationChanging(event : LocationChangeEvent) : void
		{
			trace(event.location);
		}
	}
}
