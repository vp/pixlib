/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */
package net.pixlib.display
{
	import net.pixlib.core.PXApplication;	import net.pixlib.log.PXStringifier;	import flash.display.DisplayObject;	import flash.display.Sprite;
	/**	 * The PXLayerManager class allow easy display list layout management.	 * 	 * @example Create High top sprite	 * <listing>	 * 	 * var popupChild : Sprite = PXLayerManager.getInstance().addHighChild(new Sprite());	 * </listing>	 * 	 * @langversion 3.0	 * @playerversion Flash 10 	 *	 * @author Romain Ecarnot	 */
	final public class PXLayerManager
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------
		/**		 * @private		 * Stores Singleton instance.		 */
		private static  var _instance : PXLayerManager ;

		/**		 * @private		 * Stores high container.		 */
		private var _highLevel : Sprite;

		/**		 * @private		 * Stores top container.		 */
		private var _topLevel : Sprite;

		/**		 * @private		 * Stores content container.		 */
		private var _contentLevel : Sprite;

		/**		 * @private		 * Stores bottom container.		 */
		private var _bottomLevel : Sprite;

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**		 * Returns singleton instance of LayerManager class.		 * 		 * @return The singleton instance of LayerManager class.		 *		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function getInstance() : PXLayerManager
		{
			if (!(_instance is PXLayerManager)) _instance = new PXLayerManager();
			return PXLayerManager._instance;
		}

		/**		 * Releases singleton instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function release() : void
		{
			if (PXLayerManager._instance is PXLayerManager) 				PXLayerManager._instance = null;
		}

		/**		 * Adds child to bottom layer.		 * 		 * @param child	Display object to add.		 * 		 * @return added Display object.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function addBottomChild(child : DisplayObject) : DisplayObject
		{
			return _bottomLevel.addChild(child);
		}

		/**		 * Adds child to content layer.		 * 		 * @param child	Display object to add.		 * 		 * @return added Display object.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function addContentChild(child : DisplayObject) : DisplayObject
		{
			return _contentLevel.addChild(child);
		}

		/**		 * Adds child to top layer.		 * 		 * @param child	Display object to add.		 * 		 * @return added Display object.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function addTopChild(child : DisplayObject) : DisplayObject
		{
			return _topLevel.addChild(child);
		}

		/**		 * Adds child to high layer.		 * 		 * @param child	Display object to add.		 * 		 * @return added Display object.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function addHighChild(child : DisplayObject) : DisplayObject
		{
			return _highLevel.addChild(child);
		}
		
		/**		 * Returns string representation of instance.		 * 		 * @return The string representation of instance.		 *		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**		 * Inits layer manager.		 *		 * @langversion 3.0		 * @playerversion Flash 10		 * @playerversion AIR 1.5		 */
		protected function init() : void
		{
			_bottomLevel = PXApplication.getInstance().root.addChild(new Sprite()) as Sprite;
			_bottomLevel.tabEnabled = false;
			_contentLevel = PXApplication.getInstance().root.addChild(new Sprite()) as Sprite;
			_contentLevel.tabEnabled = false;
			_topLevel = PXApplication.getInstance().root.addChild(new Sprite()) as Sprite;
			_topLevel.tabEnabled = false;
			_highLevel = PXApplication.getInstance().root.addChild(new Sprite()) as Sprite;
			_highLevel.tabEnabled = false;
		}

		// --------------------------------------------------------------------
		// Private implementation
		// --------------------------------------------------------------------
		/**		 * @private		 */
		function PXLayerManager()
		{
			init();
		}
	}
}