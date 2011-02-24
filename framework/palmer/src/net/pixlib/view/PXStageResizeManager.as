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
package net.pixlib.view
{
	import net.pixlib.core.PXApplication;
	import flash.events.Event;

	/**
	 * The PXStageResizeManager allow to centralize stage resizing workflow.
	 * 
	 * <p>Register <code>PXStageResizable</code> instance in order to be updated 
	 * when stage is resized.</p>
	 * 
	 * @example
	 * <listing>
	 * package
	 * {
	 * 	public class ThumbContainer extends Sprite implement PXStageResizable
	 * 	{
	 * 		public function ThumbContainer()
	 * 		{
	 * 			PXStageResizeManager.register(this);
	 * 		}
	 * 		
	 * 		public function resize() : void
	 * 		{
	 * 			
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @see PXStageResizable
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 *
	 * @author Romain Ecarnot
	 * @author Michael Barbero
	 */
	final public class PXStageResizeManager
	{
		/**
		 * @private
		 */
		private static var _targets : Vector.<PXStageResizable> = new Vector.<PXStageResizable>();

		/**
		 * Triggers resize
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function resize() : void
		{
			_onResize(null);
		}

		/**
		 * Registers passed-in <code>PXStageResizable</code> instance 
		 * in manager to be updated when stage is resized.
		 * 
		 * @param target A <code>PXStageResizable</code> instance to update
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function register(target : PXStageResizable) : void
		{
			if (_targets.length == 0)
			{
				PXApplication.getInstance().root.stage.addEventListener(Event.RESIZE, _onResize);
			}

			_targets.push(target);
		}

		/**
		 * Unregisters passed-in <code>PXStageResizable</code> instance 
		 * from manager.
		 * 
		 * @param target A <code>PXStageResizable</code> instance to remove.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function unregister(target : PXStageResizable) : void
		{
			if (!target) return;

			var len : uint = _targets.length;
			for (var i : uint = 0; i < len; i++)
			{
				if ( _targets[i] === target )
				{
					_targets.splice(i, 1);
					break;
				}
			}

			if (_targets.length == 0)
			{
				PXApplication.getInstance().root.stage.removeEventListener(Event.RESIZE, _onResize);
			}
		}

		/**
		 * @private
		 * 
		 * Updates all registered targets when stage is resized.
		 */
		private static function _onResize(event : Event) : void
		{
			for each (var target : PXStageResizable in _targets)
			{
				target.resize(PXApplication.getInstance().size);
			}
		}

		/**
		 * @private
		 */
		function PXStageResizeManager()
		{

		}
	}
}
