package kr.co.seoulit.logistics.logiinfosvc.compinfo.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class ImageTO extends BaseTO{
   
   private String itemGroupCode;
   private String image;
   private String explanation;
 
}