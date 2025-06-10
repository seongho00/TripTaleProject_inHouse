package com.example.demo.repository;

import java.time.LocalDateTime;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.KakaoMember;

@Mapper
public interface KakaoOAuthRepository {

	public KakaoMember getKakaoMemberById(String id);

	public void doJoin(String id, LocalDateTime regDate, LocalDateTime updateDate, String nickname, String email,
			String profileImage);

}
