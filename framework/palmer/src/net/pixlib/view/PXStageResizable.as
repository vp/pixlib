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

	import net.pixlib.structures.PXDimension;
	/**
	 * PXStageResizable interface defines Object which should listen for 
	 * application stage resizing event.
	 * 
	 * <p>Registers <code>PXStageResizable</code> instances into 
	 * <code>PXStageResizeManager</code> manager to be updated when stage 
	 * was resized.</p>
	 * 
	 * @example
	 * <listing>
	 * 
	 * package
	 * {
	 * 	public class ThumbContainer extends Sprite implement PXStageResizable
	 * 	{
	 * 		public function ThumbContainer()
	 * 		{
	 * 			PXStageResizeManager.getInstance().register(this);
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
	 * @see PXStageResizeManager
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 *
	 * @author Romain Ecarnot
	 */
	public interface PXStageResizable
	{
		/**
		 * Triggered when stage is resized.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function resize( applicationSize : PXDimension = null ) : void;
	}
}
