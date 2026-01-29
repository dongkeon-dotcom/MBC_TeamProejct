package com.mbcTeam.product;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductDao dao;

	@Transactional
	@Override
	public void insert(ProductVO vo, List<ProductImgVO> imgList, List<ProductOptionVO> options) {
		// 상품 등록
		dao.insert(vo);

		// 이미지 등록
		for (ProductImgVO img : imgList) {
			img.setProductIdx(vo.getProductIdx());
			dao.insertImg(img);
		}

		// 옵션 등록
		if (options != null) {
			for (ProductOptionVO option : options) {
				option.setProductIdx(vo.getProductIdx());
				dao.insertOption(option);
			}
		}
	}

	@Override
	public void update(ProductVO vo) {
		dao.update(vo);
	}

	@Override
	public void delete(ProductVO vo) {
		dao.delete(vo);
	}

	@Override
	public List<ProductVO> select(ProductVO vo) {
		return dao.select(vo);
	}

	@Override
	public ProductVO edit(ProductVO vo) {
		return dao.edit(vo);
	}

	@Override
	public void insertOption(ProductOptionVO option) {
		dao.insertOption(option);

	}
}
