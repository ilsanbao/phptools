<?php

class JSONKit
{
    /**
     * @param $value
     * @param $options
     * @return string
     * @throws JSONException
     */
    public static function encode($value, $options)
    {
        $encode = json_encode($value, $options);
        if (json_last_error() !== JSON_ERROR_NONE)
        {
            throw new JSONException(json_last_error_msg());
        }

        return $encode;
    }

    /**
     * @param $string
     * @param bool $array
     * @return array
     * @throws JSONException
     */
    public static function decode($string, $array = TRUE)
    {
        $decode = json_decode($string, $array);
        if (json_last_error() !== JSON_ERROR_NONE)
        {
            throw new JSONException(json_last_error_msg());
        }

        return $decode;
    }
}

class JSONException extends Exception
{
    
}
